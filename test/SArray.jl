@testset "SArray" begin
    @testset "Inner Constructors" begin
        @test SArray{(1,),Int,1,1}((1,)).data === (1,)
        @test SArray{(1,),Float64,1,1}((1,)).data === (1.0,)
        @test SArray{(2,2),Float64,2,4}((1, 1.0, 1, 1)).data === (1.0, 1.0, 1.0, 1.0)

        # Bad input
        @test_throws Exception SArray{(1,),Int,1,1}()
        @test_throws Exception SArray{(2,),Int,1,2}((1,))
        @test_throws Exception SArray{(1,),Int,1,1}(())

        # Bad parameters
        @test_throws Exception SArray{(1,),Int,1,2}((1,))
        @test_throws Exception SArray{(1,),Int,2,1}((1,))
        @test_throws Exception SArray{(1,),1,1,1}((1,))
        @test_throws Exception SArray{(2,),Int,1,1}((1,))
    end

    @testset "Outer constructors and macro" begin
        @test SArray{(1,),Int,1}((1,)).data === (1,)
        @test SArray{(1,),Int}((1,)).data === (1,)
        @test SArray{(1,)}((1,)).data === (1,)

        @test SArray{(2,2),Int,2}((1,2,3,4)).data === (1,2,3,4)
        @test SArray{(2,2),Int}((1,2,3,4)).data === (1,2,3,4)
        @test SArray{(2,2)}((1,2,3,4)).data === (1,2,3,4)

        @test ((@SArray [1])::SArray{(1,)}).data === (1,)
        @test ((@SArray [1,2])::SArray{(2,)}).data === (1,2)
        @test ((@SArray Float64[1,2,3])::SArray{(3,)}).data === (1.0, 2.0, 3.0)
        @test ((@SArray [1 2])::SArray{(1,2)}).data === (1, 2)
        @test ((@SArray Float64[1 2])::SArray{(1,2)}).data === (1.0, 2.0)
        @test ((@SArray [1 ; 2])::SArray{(2,1)}).data === (1, 2)
        @test ((@SArray Float64[1 ; 2])::SArray{(2,1)}).data === (1.0, 2.0)
        @test ((@SArray [1 2 ; 3 4])::SArray{(2,2)}).data === (1, 3, 2, 4)
        @test ((@SArray Float64[1 2 ; 3 4])::SArray{(2,2)}).data === (1.0, 3.0, 2.0, 4.0)

        @test ((@SArray [i*j*k for i = 1:2, j = 2:3, k = 3:4])::SArray{(2,2,2)}).data === (6, 12, 9, 18, 8, 16, 12, 24)
        @test ((@SArray Float64[i*j*k for i = 1:2, j = 2:3, k =3:4])::SArray{(2,2,2)}).data === (6.0, 12.0, 9.0, 18.0, 8.0, 16.0, 12.0, 24.0)

        @test (ex = macroexpand(:(@SArray [1 2; 3])); isa(ex, Expr) && ex.head == :error)
    end

    @testset "Methods" begin
        m = @SArray [11 13; 12 14]

        @test isimmutable(m) == true

        @test m[1] === 11
        @test m[2] === 12
        @test m[3] === 13
        @test m[4] === 14

        @test Tuple(m) === (11, 12, 13, 14)

        @test size(m) === (2, 2)
        @test size(typeof(m)) === (2, 2)
        @test size(SArray{(2,2),Int,2}) === (2, 2)
        @test size(SArray{(2,2),Int}) === (2, 2)
        @test size(SArray{(2,2)}) === (2, 2)

        @test size(m, 1) === 2
        @test size(m, 2) === 2
        @test size(typeof(m), 1) === 2
        @test size(typeof(m), 2) === 2

        @test length(m) === 4

        @test_throws Exception m[1] = 1
    end
end
