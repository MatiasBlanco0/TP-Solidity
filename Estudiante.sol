// SPDX-License-identifier: MIT
pragma solidity ^0.8.10;

contract Estudiante{
    string private _nombre;
    string private _apellido;
    string private _curso;
    address private _docente;
    mapping (string => int) _notas_materias;

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

    function set_nota_materia(int nota_, string memory materia_) public{
        require(msg.sender == _docente, "Solo el docente del alumno puede modificar las notas");
        
    }

}