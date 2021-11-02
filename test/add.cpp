#include <stdlib.h>
#include <Halide.h>

void compile_func(const std::vector<Halide::Argument> &arg_types, Halide::Func &f, const std::string name, Halide::Target hl_target)
{
    Halide::Pipeline p({f});
    p.print_loop_nest();

    hl_target = hl_target
                  .with_feature(Halide::Target::NoBoundsQuery)
                  .with_feature(Halide::Target::NoAsserts)
                  .with_feature(Halide::Target::NoRuntime)
                  .with_feature(Halide::Target::DisableLLVMLoopOpt);

    //f.compile_to_lowered_stmt(name + ".html", arg_types, Halide::HTML);
    f.compile_to_lowered_stmt(name + ".stmt", arg_types);
    f.compile_to_llvm_assembly(name + ".ll", arg_types, hl_target);
    f.compile_to_assembly(name + ".s", arg_types, hl_target);
    //f.compile_to_header("testgen.h", arg_types);
    //f.compile_to_file("libhalide_" + name, arg_types);
}

void testgen()
{
    Halide::ImageParam in1_i8{Halide::Int(32), 1, "in1_i8"};
    Halide::Var x{"x"};
    Halide::Func f("vadd");

    // algorithm
    f(x) = x + 3;

    // schedule
    f.vectorize(x, 8).unroll(x, 4);

    // compile
    const std::vector<Halide::Argument> arg_types{in1_i8};

    Halide::Target hl_target = Halide::get_target_from_environment();
    hl_target = Halide::Target(Halide::Target::OS::NoOS, Halide::Target::Arch::RISCV, 64, {Halide::Target::Feature::RVV});
    setenv("HL_LLVM_ARGS", "-riscv-v-vector-bits-min 128", 0);
    compile_func(arg_types, f, "kernel_vadd", hl_target);
}

int main()
{
    testgen();
    return 0;
}
