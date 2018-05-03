def _ruby_toolchain_impl(ctx):
  return [platform_common.ToolchainInfo(
      interpreter = ctx.attr.interpreter,
  )]

_ruby_toolchain = rule(
    implementation = _ruby_toolchain_impl,
    attrs = {
        "interpreter": attr.label(
            mandatory = True,
            allow_files = True,
            executable = True,
            cfg = "target",
        ),
        "runtime": attr.label(
            mandatory = True,
            allow_files = True,
            cfg = "data",
        )
    },
)

def ruby_toolchain(name, interpreter, runtime, host, target=None, **kwargs):
  impl_name = name + "-impl"
  if not target:
    target = host

  _ruby_toolchain(
      name = impl_name,
      interpreter = interpreter,
      runtime = runtime,
  )

  native.toolchain(
      name = name,
      toolchain_type = "@com_github_yugui_rules_ruby//ruby/toolchain:toolchain",
      toolchain = ":%s" % impl_name,
      exec_compatible_with = [host],
      target_compatible_with = [target],
      **kwargs
  )
