package("glslang")

    set_homepage("https://github.com/KhronosGroup/glslang/")
    set_description("Khronos-reference front end for GLSL/ESSL, partial front end for HLSL, and a SPIR-V generator.")
    set_license("Apache-2.0")

    add_urls("https://github.com/KhronosGroup/glslang.git")
    add_versions("1.2.154+1", "bacaef3237c515e40d1a24722be48c0a0b30f75f")

    add_deps("cmake")
    add_deps("spirv-tools", "python 3.x")

    on_install("linux", "windows", "macosx", function (package)
        io.gsub("CMakeLists.txt", "ENABLE_OPT OFF", "ENABLE_OPT ON")
        local configs = {"-DENABLE_CTEST=OFF"}
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs, {packagedeps = {"spirv-tools"}})
    end)

    on_test(function (package)
        os.vrun("glslangValidator --version")
        assert(package:has_cxxfuncs("ShInitialize", {includes = "glslang/Public/ShaderLang.h"}))
    end)
