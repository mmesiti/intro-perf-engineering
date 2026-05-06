# Little julia script
using Plots,BenchmarkTools

# This is inspired by:
# https://en.algorithmica.org/hpc/cpu-cache/associativity/
# This creates an array of 16MB of size.
Arr = zeros(Int32, 2^22)

function incrementing_loop(Arr::Vector{Int32}, stride::Int, max_iterations = nothing)
    iterations = 0
    limit = min(size(Arr, 1),if isnothing(max_iterations) typemax(Int64) else max_iterations*stride end)
    for i in 1:stride:limit
        iterations += 1
        Arr[i] += 1
    end
    return iterations
end

# To make sure we compile
incrementing_loop(zeros(Int32,2^22), 512)

function test_stride(stride)
    x = @btimed incrementing_loop(Arr, $stride)
    println("Iteration per second with stride=$stride: ", x.value / x.time)
end

# Surprisingly slow case: stride = 256
println("Pathological case:")
test_stride(256)
# normal case: stride = 255 and 257
println("Regular case:")
test_stride(255)
test_stride(257)


function run_scan_and_make_plot()
    Arr = zeros(Int32, 2^22)
    data = run_cache_associativity_test_scan(Arr)
    p = scatter(data.strides, data.times)
    savefig(p,"cache-associativity.png")
end



function run_cache_associativity_test_scan(Arr = Arr)
    incrementing_loop(Arr, 1)
    min_stride = 16
    max_stride = 512
    max_iterations = Int(floor(size(Arr,1)/128))
    times = [
        begin
            x = @btimed incrementing_loop($Arr, $stride, $max_iterations)
            d = x.value / x.time
            println("Stride: $stride, iterations per second: $d")
            d
        end for stride in min_stride:max_stride 
]
    (strides = collect(min_stride:max_stride), times = times)
end


