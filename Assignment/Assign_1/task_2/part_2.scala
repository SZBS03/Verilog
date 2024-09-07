package task_2

object part_2 {
  def CharArray(start: Int): List[Char] = {
    def alphabets(i: Int, acc: List[Char]): List[Char] = {     //defining recursive function 
      if(i>122) acc
      else alphabets(i+1,acc:+i.toChar)     //converting from i's int-nature to char-nature
    }
    alphabets(start,List())       //tail recursion
  }

  def main(args: Array[String]): Unit = {
    println(CharArray(97))
  }
}


