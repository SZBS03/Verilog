virtual class animal;
    int age = 1;
    string name = "x";

    function new(int a, string n);
        age = a;
        name = n;
    endfunction : new

    pure virtual function void makesound();

    static function string specie_name();
        return "Unknown";
    endfunction

    function string get_name();
        return name;
    endfunction : get_name

    function int get_age();
        return age;
    endfunction : get_age 
endclass : animal

class lion extends animal;
    bit thorn_in_paw = 0;
    function new(int age, string name);
        super.new(age, name);    
    endfunction : new 

    static function string specie_name();
        return "lion"; 
    endfunction

    function void makesound();
        $display("The Lion says Roar!");
    endfunction : makesound
endclass : lion 

class chicken extends animal;
     
    function new(int age, string name);
        super.new(age, name);    
    endfunction : new
    
    static function string specie_name();
        return "chicken"; 
    endfunction

    function void makesound();
        $display("The chicken says kakaw!");
    endfunction : makesound
endclass : chicken

class animal_factory;
    static function animal make_animal(string species,int age,string name);
    chicken chicken;
    lion lion; 
    case (species)
        "lion": begin
            lion = new(age,name);
             return lion;
        end
        "chicken": begin
            chicken = new(age, name);
            return chicken;
        end
        default: 
            $fatal(1,{"no such animal:", species});

    endcase // case(species)
    endfunction : make_animal
endclass : animal_factory

class animal_cage #(type t);
    protected static t cage[$];
    static function void cage_animal(t l);
        cage.push_back(l);
    endfunction : cage_animal

    static function void display_animals();
        $display("%s's cage contains: ",t::specie_name());
        foreach (cage[i]) begin
            $display(cage[i].get_name());
            $display("AGE : %0d",cage[i].age); end
    endfunction : display_animals
endclass : animal_cage

module factory;
    bit cast_ok = 1'b0;
    initial begin
        animal animal_h;
        lion lion_h;
        chicken chicken_h;
        animal_h =  animal_factory::make_animal("lion",15,"Musafa");
        animal_h.makesound();
        cast_ok = $cast(lion_h, animal_h);
        if (~cast_ok) $fatal(1,"failed to cast animal_h to lion_h");
        if (lion_h.thorn_in_paw) $display("animal looks angry!");
        if (!$cast(lion_h,animal_factory::make_animal("lion",9, "simba")))
            $fatal(1,"failed t cast animal from lion_h");
        animal_cage #(lion)::cage_animal(lion_h);
        if (!$cast(chicken_h,animal_factory::make_animal("chicken",2, "Clucker")))
            $fatal(1,"failed t cast animal from chicken_h");
        animal_cage #(chicken)::cage_animal(chicken_h);
        animal_cage #(lion)::display_animals();
        animal_cage #(chicken)::display_animals();
    end
endmodule