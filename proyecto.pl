% Definiciones de la base de conocimientos 

% Días de la semana en los que se pasa consulta
dia(lunes).
dia(martes).
dia(miercoles).
dia(jueves).
dia(viernes).

% Horas en las que se pasa consulta
hora(8, 00).
hora(8, 30).
hora(9, 00).
hora(9, 30).
hora(10, 00).
hora(10, 30).
hora(11, 00).
hora(11, 30).
hora(12, 30).
hora(13, 00).
hora(13, 30).
hora(14, 00).
hora(14, 30).
hora(15, 00).
hora(15, 30).

% Doctores y doctoras disponibles en el cuadro médico, junto a los diferentes departamentos existentes
facultativo('Dermatología', 'Dr. Luis Quintos').
facultativo('Medicina Interna', 'Dra. Matilde Pamparacuatro').
facultativo('Medicina Interna', 'Dr. Felipe Santos').
facultativo('Medicina Interna', 'Dra. Angustias Expósito').
facultativo('Traumatología', 'Dr. José Pino').
facultativo('Traumatología', 'Dra. Luisa Botella').

% Departamentos de las diferentes especialidades existentes
departamento('Dermatología').
departamento('Medicina Interna').
departamento('Traumatología').


% Se asigna de manera dinámica el predicado ‘cita’ de aridad 6
% Teniendo el nombre del paciente, la hora de la cita, los minutos, el día de la semana, la especialidad en la que tiene la cita el paciente y el facultativo con el que tiene la cita
% Además, facultativo, se añade también de manera dinámica, es decir, lo tenemos de manera estática arriba como definición en la base del conocimiento y posibilitamos que se pueda añadir de manera dinámica nuevos facultativos a los departamentos
% Lo mismo pasaría con los departamentos de las diferentes especiales que están algunos de manera predefinida en la base del conocimiento pero se permite añadir nuevos de manera dinámica
:- dynamic cita/6.
:- dynamic facultativo/2.
:- dynamic departamento/1.

% Regla para que los pacientes puedan concertar citas
concertar_cita(Paciente, Especialidad) :-
    dia(Dia),
    hora(Hora, Minutos),
    facultativo(Especialidad, Facultativo),
    % Verificación de la disponibilidad de la hora, el día y el facultativo
    not(cita(_, Hora, Minutos, Dia, Especialidad, Facultativo)),
    % Verificación para que el paciente no tenga ya una cita ese mismo día y hora
    not(cita(Paciente, Hora, Minutos, Dia, _, _)),
   % Verificación para que el paciente no tenga ya una cita con una misma especialidad el mismo día
    not(cita(Paciente, _, _, Dia, Especialidad, _)),
    % Reserva de una cita al paciente
    assert(cita(Paciente, Hora, Minutos, Dia, Especialidad, Facultativo)),
    write('-----------------------------'), nl, 
    write('RESERVADA cita presencial'), nl, 
    write('Especialidad: '), write(Especialidad), nl,
    write('Facultativo: '), write(Facultativo), nl,
    write('Día: '), write(Dia), write('. Hora: '), write(Hora), write(':'), write(Minutos), nl,
    write('Nombre del Paciente: '), write(Paciente), nl.

% Regla para mostrar todas las citas asignadas
ver_citas :-
    cita(Paciente, Hora, Minutos, Dia, Especialidad, Facultativo),
    write('*************'), nl, 
    write('Especialidad: '), write(Especialidad), nl, 
    write('Facultativo: '), write(Facultativo), nl, 
    write('Paciente: '), write(Paciente), nl,
    write('Fecha: '), write(Dia), write(', '), write(Hora), write(':'), write(Minutos), nl,
   false. % Fuerza a la ‘vuelta atrás’ (backtracking) para seguir buscando
ver_citas. % Caso base de la recursividad. Detener el bucle

% Regla para que los pacientes puedan cancelar citas
cancelar_cita(Paciente, Dia, Especialidad) :-
    write('===========================¡!'), nl,
    retract(cita(Paciente, Hora, Minutos, Dia, Especialidad,_)),
    write('Cita cancelada la cita del paciente '), write(Paciente),
    write(' del día '), write(Dia), write(' a las '), write(Hora), write(':'), write(Minutos), nl.


% Regla para consultar la agenda de un facultativo específico
agenda_facultativo(Facultativo) :-
    cita(Paciente, Hora, Minutos, Dia, Especialidad, Facultativo),
    write('//////////////////////////////////////////'), nl, 
    write('AGENDA del facultativo: '), write(Facultativo), nl, 
    write('Especialidad: '), write(Especialidad), nl, 
    write('Paciente: '), write(Paciente), nl,
    write('Fecha: '), write(Dia), write(', '), write(Hora), write(':'), write(Minutos), nl,
    false. % Fuerza a la ‘vuelta atrás’ (backtracking) para seguir buscando
agenda_facultativo(_). % Caso base de la recursividad. Detener el bucle

% Regla para consultar la agenda de citas de un departamento específico 
agenda_departamento(Especialidad) :-
    cita(Paciente, Hora, Minutos, Dia, Especialidad, Facultativo),
    write('//////////////////////////////////////////'), nl, 
    write('AGENDA del departamento de la especialidad: '), write(Especialidad), nl, 
    write('Facultativo: '), write(Facultativo), nl, 
    write('Paciente: '), write(Paciente), nl,
    write('Fecha: '), write(Dia), write(', '), write(Hora), write(':'), write(Minutos), nl,
    false. % Fuerza a la ‘vuelta atrás’ (backtracking) para seguir buscando
agenda_departamento(_). % Caso base de la recursividad. Detener el bucle


% Regla para consultar cuáles son los pacientes de un facultativo específico, devuelve una lista
pacientes_facultativo(Facultativo, Pacientes) :-
    write('//////////////////////////////////////////'), nl,
    write('Pacientes del facultativo '), write(Facultativo), write(':'),nl,
    findall(Paciente, cita(Paciente, _, _, _, _, Facultativo), Pacientes).

% Regla para consultar cuáles son los facultativos que conforman un departamento de una determinada especialidad, devuelve una lista
facultativos_departamento(Especialidad, Facultativos) :-
    write('//////////////////////////////////////////'), nl,
    write('Facultativos de la especialidad '), write(Especialidad), write(':'),nl,
    findall(Facultativo, facultativo(Especialidad, Facultativo), Facultativos).





% Regla para añadir a un facultativo específico a una especialidad, se requiere tener la contraseña correcta para hacerlo
anadir_facultativo(Especialidad, Facultativo, Contrasena) :-
    % Se debe introducir la contraseña correcta
    Contrasena = 'admin1234',
    write('CONTRASEÑA CORRECTA'), nl,
    % El departamento de la especialidad debe existir
    departamento(Especialidad),
    write('El facultativo '), write(Facultativo), write(' ha sido añadido al departamento '),
    write(Especialidad), nl,
    % Se comprueba primero que ese facultativo no esté ya en la especialidad
    not(facultativo(_, Facultativo)),
    assert(facultativo(Especialidad, Facultativo)).

% Regla para añadir a un departamento, se requiere tener la contraseña correcta para hacerlo
anadir_departamento(Especialidad, Contrasena) :-
    % Se debe introducir la contraseña correcta
    Contrasena = 'admin1234',
    write('CONTRASEÑA CORRECTA'), nl,
    % El departamento no debe existir ya
    not(departamento(Especialidad)),
    write('Se ha añadido el departamento: '), write(Especialidad), nl,
    assert(departamento(Especialidad)).

% Regla para que los pacientes puedan concertar citas con un facultativo específico
concertar_cita_facultativo(Paciente, Facultativo) :-
    dia(Dia),
    hora(Hora, Minutos),
    facultativo(Especialidad, Facultativo),
    % Verificación de la disponibilidad de la hora
    not(cita(_, Hora, Minutos, Dia, Especialidad, Facultativo)),
    % Verificación para que el paciente no tenga ya una cita ese mismo día y hora
    not(cita(Paciente, Hora, Minutos, Dia, _, _)),
   % Verificación para que el paciente no tenga ya una cita con una misma especialidad el mismo día
    not(cita(Paciente, _, _, Dia, Especialidad, _)),
    % Reserva de una cita al paciente
    assert(cita(Paciente, Hora, Minutos, Dia, Especialidad, Facultativo)),
    write('-----------------------------'), nl, 
    write('RESERVADA cita presencial'), nl, 
    write('Especialidad: '), write(Especialidad), nl,
    write('Facultativo: '), write(Facultativo), nl,
    write('Día: '), write(Dia), write('. Hora: '), write(Hora), write(':'), write(Minutos), nl,
    write('Nombre del Paciente: '), write(Paciente), nl.



% Regla para consultar las citas que tiene un paciente específico
citas_paciente(Paciente, Citas) :-
    write('//////////////////////////////////////////'), nl,
    write('Citas del paciente '), write(Paciente), write(':'),nl,
    findall([Especialidad, Facultativo, Dia, Hora, Minutos],
            cita(Paciente, Hora, Minutos, Dia, Especialidad, Facultativo),
            Citas).

listar_departamentos(Departamentos) :-
	write('//////////////////////////////////////////'), nl,
    write('Listado de departamentos:'), nl,
    findall(Especialidad, departamento(Especialidad), Departamentos).


listar_facultativos(Facultativos) :-
    write('//////////////////////////////////////////'), nl,
    write('Listado de facultativos por departamento:'), nl,
    findall([Facultativo, Especialidad],
            facultativo(Especialidad, Facultativo),
            Facultativos).
