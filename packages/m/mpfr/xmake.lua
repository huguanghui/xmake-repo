package("mpfr")

    set_homepage("https://www.mpfr.org/")
    set_description("The MPFR library is a C library for multiple-precision floating-point computations with correct rounding.")
    set_license("LGPL-3.0")

    add_urls("https://www.mpfr.org/mpfr-current/mpfr-$(version).tar.gz")
    add_versions("4.1.0", "3127fe813218f3a1f0adf4e8899de23df33b4cf4b4b3831a5314f78e65ffa2d6")

    add_deps("gmp")
    on_install("macosx", "linux", function (package)
        local configs = {"--disable-dependency-tracking", "--with-pic"}
        if package:config("shared") then
            table.insert(configs, "--enable-shared=yes")
            table.insert(configs, "--enable-static=no")
        else
            table.insert(configs, "--enable-static=yes")
            table.insert(configs, "--enable-shared=no")
        end
        import("package.tools.autoconf").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("mpfr_get_version", {includes = "mpfr.h"}))
    end)
