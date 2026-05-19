# this is inspired by
# https://en.algorithmica.org/hpc/cpu-cache/latency/
using Random
using BenchmarkTools
using Test
using Plots
using Optim
using Printf
using JLD2

function main(measure_again)
    minimal_random_vs_ordered_comparison() 

    array_sizes,measurements = if measure_again get_data() else read_data() end

    results = fit_latency_model_to_experimental_data(array_sizes,measurements,lock_sizes=false)

    plot_latency_data(array_sizes,measurements)
    plot_latency_model(results,array_sizes)
    print_results(results)
    savefig("latency.png")
end

#

function minimal_random_vs_ordered_comparison()
    array_random_order = get_self_referential_array_random_order(2^21)
    all_indices = collect(1:2^21)
    array_ordered = get_self_referential_array_ordered(size(all_indices, 1))

    println("Visiting 16MB array in random order:")
    println("Latency: ", measure_latency(array_random_order))
    println("Visiting 16MB array in ordered manner:")
    println("Latency: ", measure_latency(array_ordered))
end

function get_data()
    min_size=20_000
    max_size=20_000_000
    array_sizes, measurements =  get_latency_data(min_size, max_size)

    save_data(array_sizes,measurements)
    return array_sizes, measurements

end


function get_latency_data(min_size, max_size)
    array_sizes = sizes_to_test(min_size, max_size)
    measured_latencies = [
        begin
            println("measuring for size: $s (bytes)")
            measure_latency_unordered(array_byte_size=s)
        end
        for s in array_sizes
    ]
    return array_sizes, measured_latencies
end

function save_data(array_sizes,measurements; filename = "latency_data.jld2")
    save(filename, Dict("array_sizes"=>array_sizes,
                        "measurements"=> measurements))
    return filename
end
function read_data(; filename = "latency_data.jld2")
    data =  load(filename)

    return data["array_sizes"], data["measurements"]
end


function fit_latency_model_to_experimental_data(array_sizes, measurements; lock_sizes= true)
    p0 = get_initial_parameter_estimate()
    return fit_data(array_sizes,measurements,p0,lock_sizes=lock_sizes)
end

function plot_latency_data(array_sizes, measured_latencies)
    scatter!(array_sizes, measured_latencies, yscale=:log10, xscale=:log10, label="data",minorgrid=true)
end

function plot_latency_model(params,array_sizes)
    latency_theo = (array_size -> latency_model(array_size, params)).(array_sizes)
    xlabel!("Array size (Bytes)")
    ylabel!("Average Latency (s)")
    scatter!(array_sizes, latency_theo, yscale=:log10, xscale=:log10, label="model",minorgrid=true)
end

function print_results(results)
    levels = Int((size(results, 1) - 1) / 2)
    println("Fit results (assuming 3 cache levels + dram):")
    for (size, latency) in zip(results[1:levels], results[levels+1:end])
        @printf "\tsize: %i KiB latency: %1.f ns\n" size/1024 latency*1.e9
    end
    @printf "\tMain memory latency: %1.2f ns\n" results[end]*1e9
end

##

function get_self_referential_array_random_order(array_size::Int64)
    all_indices = collect(1:array_size)
    single_cycle_array_visiting_order = shuffle(all_indices)
    res = similar(single_cycle_array_visiting_order)

    k = single_cycle_array_visiting_order[end]
    for i in eachindex(single_cycle_array_visiting_order)
        res[k] = single_cycle_array_visiting_order[i]
        k = res[k]
    end
    return res
end

function get_self_referential_array_ordered(size)
    res = collect(2:size+1)
    res[end] = 1
    return res
end

function measure_latency(access_pattern::Vector{Int64})
    t = @btimed pointer_chasing($access_pattern)
    latency = t.time / size(access_pattern, 1)
    return latency
end

sizes_to_test(min, max) = [round(Int, min * 1.5^i) for i in 0:200 if min * 1.5^i < max]

function measure_latency_unordered(; array_byte_size::Int64)
    array_size = Int64(ceil(array_byte_size / 8))
    access_pattern = get_self_referential_array_random_order(array_size)
    t = @btimed pointer_chasing($access_pattern)
    latency = t.time / size(access_pattern, 1)
    return latency
end

function get_initial_parameter_estimate(;really=false)
    # associativity * nsets * cache line size
    # from likwid-topology
    size_l1 = 12*64*64 
    size_l2 = 20*1026*64 
    size_l3 = 8*16384*64 

    sizes = [size_l1, size_l2, size_l3]
    if ! really
        latencies = [1.1434e-9, 5.1876736e-9, 1.9902189e-8, 3.9804378e-8]
    else
        latency_l1 = measure_latency_unordered(array_byte_size=size_l1)
        latency_l2 = measure_latency_unordered(array_byte_size=size_l2)
        latency_l3 = measure_latency_unordered(array_byte_size=size_l3)
        latency_dram = latency_l3*2
        latencies = [latency_l1, latency_l2, latency_l3, latency_dram]
    end 


    [sizes..., latencies...]
end


function fit_data(array_sizes, measured_latencies,p0;lock_sizes=true)
    println("Getting initial estimate")
    println("Initial estimate: ", p0)

    nlevels = cld(length(p0),2)
    if lock_sizes
        let sizes = p0[1:nlevels],
            latencies0 = p0[nlevels+1:end],
            model(x, latencies) = [latency_model(s, [sizes..., latencies...]) for s in x],
            residual(latencies) = sum(((model(array_sizes, latencies) .- measured_latencies) ./ measured_latencies) .^ 2)
   
        result = optimize(residual,latencies0) 
        [sizes...,Optim.minimizer(result)...]
        end
    else
        let model(x, p) = [latency_model(s, p) for s in x],
            residual(p) = sum(((model(array_sizes, p) .- measured_latencies) ./ measured_latencies) .^ 2)
    
        result = optimize(residual,p0) 
        Optim.minimizer(result)
        end
    end
end

function latency_model(array_size::Int64, params)
    # We do not care about the side of the dram, but about its latency
    # We also assume that the caches are exclusive
    levels = Int((length(params) - 1) / 2)
    sizes = params[1:levels]
    cumsizes = cumsum(cat([0], sizes, dims=1))
    latencies = params[levels+1:end]

    cache_contribution = sum(latency * min(size, array_size - cumsize) / array_size
                             for (size, cumsize, latency)
                             in
                             zip(sizes, cumsizes, latencies) if (array_size > cumsize))
    dram_contribution = if (array_size > sum(sizes))
        (array_size - sum(sizes)) / array_size * latencies[end]
    else
        0
    end

    return cache_contribution + dram_contribution
end

function pointer_chasing(array_of_pointers::Vector{Int64})
    k = 1
    for _ in 1:size(array_of_pointers, 1)
        k = array_of_pointers[k]
    end
end

###

function test_latency_model()
    @testset "latency model" begin

        @test latency_model(10, [10, 30, 100, 1, 5, 25, 100]) == 1
        @test latency_model(20, [10, 30, 100, 5, 5, 25, 100]) == 5
        @test latency_model(80, [10, 30, 100, 5, 5, 15, 100]) == 10
        @test latency_model(80, [10, 30, 100, 1, 5, 15, 100]) ≈ (10 * 1 + 30 * 5 + 40 * 15) / 80
        @test latency_model(600, [10, 30, 100, 1, 5, 15, 100]) ≈ (10 * 1 + 30 * 5 + 15 * 100 +
                                                                  (600 - (10 + 30 + 100)) * 100) / 600
    end
end



if (abspath(PROGRAM_FILE) == @__FILE__)
    measure_again  = false
    main(measure_again)
end
