#light

open IronRuby

let engine = Ruby.CreateEngine()
let scope = engine.CreateScope()

engine.Execute("
def mars_age(age)
   age / (686.98/365.26)
end
", scope) |> ignore

let marsAge = engine.Operations.InvokeMember(scope,"mars_age",[|box 17.0|] )

printfn "%A" marsAge
