namespace Venus

module Calculations =
 
  let venusAge (age:double) : double =
      age * (365.26/224.68)

  let venusAndCatAges(age:double) : double * double =
       venusAge(age), age * 6.2


module DU = 

  (* From Luis Diego Fallas's blog entry: ‘Some Notes on Using F# Code from IronPython’ *)
  (* http://langexplr.blogspot.com/2009/01/some-notes-on-using-f-code-from.html *)

  type MathExpr =
    | Addition of MathExpr * MathExpr
    | Subtraction of MathExpr * MathExpr
    | Literal of double
