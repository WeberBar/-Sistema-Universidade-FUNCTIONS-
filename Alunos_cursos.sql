SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
-- -----------------------------------------------------
-- Schema faculdade
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `faculdade` DEFAULT CHARACTER SET utf8mb3 ;
USE `faculdade` ;

-- -----------------------------------------------------
-- Criação tabela cursos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `faculdade`.`cursos` (
  `idCursos` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NULL DEFAULT NULL,
  `area` varchar(100) null,
  PRIMARY KEY (`idCursos`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Criação tabela alunos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `faculdade`.`alunos` (
  `idAlunos` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NULL DEFAULT NULL,
  `sobrenome` VARCHAR(100) NULL DEFAULT NULL,
  `ra` INT NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `Cursos_idCursos` INT NOT NULL,
  PRIMARY KEY (`idAlunos`, `Cursos_idCursos`),
  INDEX `fk_Alunos_Cursos_idx` (`Cursos_idCursos` ASC) VISIBLE,
  CONSTRAINT `fk_Alunos_Cursos`
    FOREIGN KEY (`Cursos_idCursos`)
    REFERENCES `faculdade`.`cursos` (`idCursos`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb3;

USE `faculdade` ;

-- -----------------------------------------------------
-- Criação da stored procedure consulta_cursos
-- -----------------------------------------------------

DELIMITER $$
USE `faculdade`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `consulta_cursos`()
begin
    select *
    from Cursos;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- Criação da stored procedure inserir_curso
-- -----------------------------------------------------

DELIMITER $$
USE `faculdade`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserir_curso`(
  IN p_nome VARCHAR(100),
  IN p_area VARCHAR(100)
)
BEGIN
  INSERT INTO Cursos (nome, area) VALUES (p_nome, p_area);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- Criação da stored procedure inserir_cursos
-- -----------------------------------------------------

DELIMITER $$
USE `faculdade`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserir_cursos`(
nome varchar(100),
area varchar(100)
)
begin
    insert into cursos (nome, area) values (nome, area);
end$$

DELIMITER ;
USE `faculdade`;

-- Criação de uma trigger 'gerar_email_aluno'
DELIMITER $$
USE `faculdade`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `faculdade`.`gerar_email_aluno`
BEFORE INSERT ON `faculdade`.`alunos`
FOR EACH ROW
BEGIN
  SET NEW.email = CONCAT(NEW.nome, '.', NEW.sobrenome, '@dominio.com');
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Chamadas para inserir cursos e consultar cursos
call faculdade.inserir_cursos('Medicina', 'biologia');
call faculdade.inserir_cursos('engenharia de computação', 'exatas');
call faculdade.inserir_cursos('Biomedicina', 'biologia');
call faculdade.inserir_cursos('Enfermagem', 'biologia');
call faculdade.inserir_cursos('advogado', 'direito');

call consulta_cursos();

-- Inserção de registros na tabela 'alunos'
INSERT INTO alunos (nome, sobrenome, ra, Cursos_idCursos) VALUES('Stephany', 'Squilaro', '232325',  11);
INSERT INTO alunos (nome, sobrenome, ra, Cursos_idCursos) VALUES('Viviane', 'Oliveira', '236025', 12);
INSERT INTO alunos (nome, sobrenome, ra, Cursos_idCursos) VALUES('Julia', 'Silva', '234125', 13);
INSERT INTO alunos (nome, sobrenome, ra, Cursos_idCursos) VALUES('Guilherme', 'Ribeiro', '235289', 14);
INSERT INTO alunos (nome, sobrenome, ra, Cursos_idCursos) VALUES('João', 'Vitor', '232569', 15);

select * from alunos;

-- Criação de uma function 'obter_id_curso'

delimiter $
CREATE FUNCTION obter_id_curso(
  p_nome_curso VARCHAR(100),
  p_area_curso VARCHAR(100)
)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE curso_id INT;
  
  SELECT idCursos INTO curso_id
  FROM Cursos
  WHERE nome = p_nome_curso AND area = p_area_curso;
  
  RETURN curso_id;
END$

DELIMITER ;
select faculdade.obter_id_curso('Biomedicina', 'biologia') as id_do_curso;

-- Criação de uma procedure 'matricular_aluno'
DELIMITER $

CREATE PROCEDURE matricular_aluno(
IN nome_aluno VARCHAR(100),
  in sobrenome varchar(100),
  IN ra_aluno VARCHAR(100),
  IN nome_curso VARCHAR(100)
)
BEGIN
  DECLARE curso_id INT;

  -- Obtém o ID do curso com base no nome do curso
  SELECT idCursos INTO curso_id
  FROM Cursos
  WHERE nome = nome_curso;

  -- Verifica se o aluno já está matriculado no curso
  IF EXISTS (SELECT 1 FROM alunos WHERE ra = ra_aluno AND Cursos_idCursos = curso_id) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Aluno já matriculado neste curso.';
  ELSE
    -- Insere o aluno na tabela Alunos
    INSERT INTO alunos (nome, sobrenome, ra, Cursos_idCursos)
    VALUES (nome_aluno,sobrenome, ra_aluno,  curso_id);
  END IF;
END$

DELIMITER ;

call faculdade.matricular_aluno('jula', 'gomes', '454584', 'Medicina');
select * from alunos;