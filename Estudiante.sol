// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Estudiante{
    string private _nombre;
    string private _apellido;
    string private _curso;
    address private _docente;
    mapping (string => uint) _notas_materias;
    string[] _materias;

    constructor(string memory nombre_, string memory apellido_, string memory curso_){
        _nombre = nombre_;
        _apellido = apellido_;
        _curso = curso_;
        _docente = msg.sender;
    }

    function apellido() public view returns(string memory){
        return _apellido;
    }

    function nombre_completo() public view returns(string memory){
        return string.concat(_nombre, _apellido);
    }

    function curso() public view returns(string memory){
        return _curso;
    }

    function set_nota_materia(uint nota_, string memory materia_) public{
        require(msg.sender == _docente, "Solo el docente del alumno puede modificar las notas");
        require(nota_ <= 100, "La nota tiene que ser un numero entero del 1 al 100");
        require(nota_ >= 1, "La nota tiene que ser un numero entero del 1 al 100");

        _materias.push(materia_);
        _notas_materias[materia_] = nota_;
    }
            
    function nota_materia(string memory materia_)public view returns(uint){
        return _notas_materias[materia_];
    }

    function aprobo(string memory materia_)public view returns(bool){
        if (_notas_materias[materia_] >= 60){
            return true;
        }
        else{
            return false;
        }
    }

    function promedio() public view returns(uint promedio_){
        promedio_ = 0;
        for(uint i = 0; i < _materias.length;i++){
            promedio_ += _notas_materias[_materias[i]];
        }
        return promedio_ / _materias.length;
    }

}