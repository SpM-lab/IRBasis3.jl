abstract type Basis end

"""
FiniteTempBasis
"""
struct FiniteTempBasis <: Basis
    o::PyObject
    u::PiecewiseLegendrePoly
    uhat::PiecewiseLegendreFT
    v::PiecewiseLegendrePoly
    s::Vector{Float64}
    statistics::Statistics
    size::Int64
end

Base.size(basis::FiniteTempBasis)::Int64 = basis.o.size
statistics(basis::FiniteTempBasis)::Statistics = basis.o.statistics

FiniteTempBasis(o::PyObject) = FiniteTempBasis(
        o, o.u, o.uhat, o.v, o.s,
        o.statistics == "F" ? fermion : boson,
        o.size
    )

"""
Create a FiniteTempBasis object by decomposing a given kernel
"""
function FiniteTempBasis(
    kernel::KernelBase, statistics::Statistics, beta::Real, eps::Union{Float64,Nothing}=nothing)
    o = sparse_ir.FiniteTempBasis(
        statistics==fermion ? "F" : "B", Float64(beta), Float64(kernel.o.lambda_/beta), eps=eps, kernel=kernel.o)
    FiniteTempBasis(o)
end


function FiniteTempBasis(
    statistics::Statistics, beta::Real, wmax::Real; eps::Union{Float64,Nothing}=nothing, kernel::Union{KernelBase,Nothing}=nothing)
    kernel_py = kernel !== nothing ? kernel.o : nothing
    o = sparse_ir.FiniteTempBasis(
        statistics==fermion ? "F" : "B", Float64(beta), Float64(wmax), eps=eps, kernel=kernel_py)
    FiniteTempBasis(o)
end


"""
Create a FiniteTempBasis object using LogisticKernel
"""
function FiniteTempBasis(beta::Real, wmax::Real, statistics::Statistics, eps::Float64)
    FiniteTempBasis(LogisticKernel(Float64(beta * wmax)), statistics, Float64(beta), eps)
end


function default_omega_sampling_points(basis::FiniteTempBasis)::Vector{Float64}
    basis.o.default_omega_sampling_points()
end


function default_tau_sampling_points(basis::FiniteTempBasis)::Vector{Float64}
    basis.o.default_tau_sampling_points()
end


function default_matsubara_sampling_points(basis::FiniteTempBasis)::Vector{Int64}
    basis.o.default_matsuba_sampling_points()
end