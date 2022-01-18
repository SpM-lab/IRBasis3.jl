using SparseIR
using Test

import PyCall: pyimport, PyNULL, PyVector

sparse_ir = pyimport("sparse_ir")

test_params = [
    (SparseIR.KernelFFlat, sparse_ir.KernelFFlat, fermion),
    (SparseIR.KernelBFlat, sparse_ir.KernelBFlat, boson)
]

@testset "sampling.MatsubaraSampling" begin
    lambda_ = 10.0
    wmax = 1.0
    eps = 1e-7
    beta = lambda_/wmax
    for (K, K_py, stat) in test_params
        basis_jl = FiniteTempBasis(K(lambda_), stat, beta, eps)
        smp_matsu_jl = SparseIR.MatsubaraSampling(basis_jl)

        stat_str = Dict(fermion => "F", boson => "B")[stat]
        basis_py = sparse_ir.FiniteTempBasis(K_py(lambda_), stat_str, beta, eps)
        smp_matsu_py = sparse_ir.MatsubaraSampling(basis_py)

        @test all(smp_matsu_jl.sampling_points .== smp_matsu_py.sampling_points)
    end
end