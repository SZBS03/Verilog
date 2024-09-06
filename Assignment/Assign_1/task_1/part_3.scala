package task_1

//Exercise 3: Figure out how to use Option type in a function parameter



object part_3 {
  private def cred(): Unit = {			//private credentials
    println("Your ID name is: #X155")
    println("Your Bank Balance is: $14,000")
  }



  private def user(x: Option[String],y: Option[String]): Unit = {

    x match{
      case Some(name) if name == "zaid" => println(s"Welcome, $name!")
      case _ => println("invalid name!")
    }

    y match{
      case Some("xppwe") => cred()
      case _ => println("Invalid password")
    }
  }


  def main(args: Array[String]): Unit = {
    user(Some("dany"),Some("jggfe"))  //invalid password
    user(Some("zaid"),Some("xppwe"))  //valid password
  }
}
