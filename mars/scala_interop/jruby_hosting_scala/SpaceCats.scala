object SpaceCats {
val planetCatAge = (planetAge: (Double) => Double) =>  
    {
      val catAge = (age:Double) => age * 6.2 
      planetAge.compose(catAge)
    }
}