"""
scipy.optimize module

- [Optimization and Root Finding (scipy.optimize) Reference Guide](https://docs.scipy.org/doc/scipy/reference/optimize.html)


# Examples

You can optimize the Rosen function:

```julia-repl
julia> x0 = [1.3, 0.7, 0.8, 1.9, 1.2];

julia> res = SciPy.optimize.minimize(SciPy.optimize.rosen, x0, method="Nelder-Mead", tol=1e-6)
Dict{Any,Any} with 8 entries:
  "fun"           => 1.94206e-13
  "nit"           => 295
  "nfev"          => 494
  "status"        => 0
  "success"       => true
  "message"       => "Optimization terminated successfully."
  "x"             => [1.0, 1.0, 1.0, 1.0, 1.0]
  "final_simplex" => ([1.0 1.0 … 1.0 1.0; 1.0 1.0 … 1.0 1.0; … ; 1.0 1.0 … 1.0 1.0; 1.0 1.0 … 1.0 1.0], [1…

```
"""
module optimize

using PyCall
import PyCall: hasproperty # Base.hasproperty in Julia 1.2

@pyinclude(joinpath(pkgdir(@__MODULE__), "src", "scipy_api_list.py"))
type2props = py"generate_scipy_apis"("optimize")

all_properties = [type2props["function"]; type2props["class"]]

import ..pyoptimize
import .._generate_docstring
import ..LazyHelp

const _ignore_funcs = ["optimize"]

for f in all_properties
    f in _ignore_funcs && continue

    sf = Symbol(f)
    @eval @doc LazyHelp(pyoptimize, $f) $sf(args...; kws...) = pycall(pyoptimize.$f, PyAny, args...; kws...)
end

function __init__()
    copy!(pyoptimize, pyimport_conda("scipy.optimize", "scipy"))
end


end # module
