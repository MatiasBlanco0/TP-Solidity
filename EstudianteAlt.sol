// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Estudiante{
    string private _nombre;
    string private _apellido;
    string private _curso;
    address private _docente;
    //La nota se guarda en un uint8 porque tiene valores del 0 al 255 y la nota es del 1 al 100
    mapping(uint8 => mapping(string => uint8)) private _notas_materias;
    //Array de strings que guarda todas las materias seteadas
    string[] private _materias;
    //Mapping de permisos
    mapping (address => bool) _permisos;

    //Evento de cuando se settea la nota
    event SetNota(address docente, string materia, uint8 bimestre, uint8 nota);

    /* Constructor del contrato
    Parametros: nombre (string), apellido (string) y curso (string)
    Actualizo los valores del contrato a los valores ingresados como parametros
    El docente es la persona que llamo al constructor */
    constructor(string memory nombre_, string memory apellido_, string memory curso_){
        _nombre = nombre_;
        _apellido = apellido_;
        _curso = curso_;
        _docente = msg.sender;
    }

    /* Funcion que al ser llamada devuelve el apellido del alumno como string */
    function apellido() public view returns(string memory){
        return _apellido;
    }

    /* Funcion que al ser llamada duelve el nombre y el apellido como un mismo string, con un espacio en el medio */
    function nombre_completo() public view returns(string memory){
        return string(bytes.concat(bytes(_nombre)," ", bytes(_apellido)));
    }

    /* Funcion que al ser llamada devuelve el curso como string */
    function curso() public view returns(string memory){
        return _curso;
    }

    function set_permisos(address other_, bool estado_) public {
        require(msg.sender == _docente, "Solo el docente del alumno puede setear permisos");

        _permisos[other_] = estado_;
    }

    /* Funcion que solo el docente que creo al Estudiante puede llamar.
    Parametros: bimestre (unit8), nota (uint8) y materia (string)
    Si el valor de la nota es mayor a 100 o menor a 1, o la funcion es llamada por alguien que no es el docente, se para la funcion
    Se pushea la materia a un array de materias y se actualiza el valor de la nota con la key bimestre y materia
    Se hace emit al evento SetNota pasando msg.sender, materia_ y nota_*/
    function set_nota_materia(uint8 bimestre_, uint8 nota_, string memory materia_) public{
        require(msg.sender == _docente || _permisos[msg.sender] == true, "Solo personas con permisos pueden modificar las notas");
        require(nota_ <= 100 && nota_ >= 1, "La nota tiene que ser un numero entero del 1 al 100");
        require(bimestre_ <= 4 && bimestre_ >= 1, "El bimestre tiene que ser un numero");

        bool existe = false;
        for(uint8 i = 0; i < _materias.length; i++){
            if (keccak256(abi.encodePacked(_materias[i])) == keccak256(abi.encodePacked(materia_))){
                existe = true;
            }
        }
        if(!existe){
            _materias.push(materia_);
        }
        _notas_materias[bimestre_][materia_] = nota_;

        emit SetNota(msg.sender, materia_, bimestre_, nota_);
    }

    /* Funcion que devuelve la nota de la materia ingresada
    Parametros: bimestre(unit8) y materia (string) */
    function nota_materia(string memory materia_, uint8 bimestre_)public view returns(uint){
        return _notas_materias[bimestre_][materia_];
    }

    /* Funcion que dice si el Estudiante aprobo una materia
    Parametros: bimestre (uint8) y materia (string)
    Devuelve true si la nota de la materia es mayor o igual a 60 (aprobado), sino false (desaprobado) */
    function aprobo(string memory materia_, uint8 bimestre_)public view returns(bool){
        if (_notas_materias[bimestre_][materia_] >= 60){
            return true;
        }
        else{
            return false;
        }
    }

    /* Funcion que devuelve el promedio
    Parametros: bimestre (uint8)
    Se suman todas las notas de cada materia,
    se usa el tamaño del array materias para saber cuantas hay, 
    _materias[i] es el nombre de la materia segun i
    _materias[bimestre][_materias[i]] es la nota de la materia en el bimestre indicado
    al final se divide el "promedio" por la cantidad de materias que hay y se devuelve el resultado*/
    function promedio(uint8 bimestre_) public view returns(uint){
        uint promedio_ = 0;
        for(uint8 i = 0; i < _materias.length;i++){
            promedio_ += _notas_materias[bimestre_][_materias[i]];
        }
        return promedio_ / _materias.length;
    }

}