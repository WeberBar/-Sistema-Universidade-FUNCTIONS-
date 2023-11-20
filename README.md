 <h1 align="center" > Sistema Universidade (FUNCTIONS)</h1>

 ### Crie um banco de dados para armazenar alunos e cursos de uma universidade
* Cada curso pode pertencer a somente uma área
  
```mysql
CREATE TABLE IF NOT EXISTS `faculdade`.`cursos` (
  `idCursos` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NULL DEFAULT NULL,
  `area` varchar(100) null,
  PRIMARY KEY (`idCursos`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb3;

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

```

### 1- Utilize Stored Procedures para automatizar a inserção e seleção dos cursos

#### inserção:
```mysql
DELIMITER $$
USE `faculdade`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_cursos`(
nome varchar(100),
area varchar(100)
)
begin
    insert into cursos (nome, area) values (nome, area);
end$$

DELIMITER ;

```

#### Seleção:
```mysql
DELIMITER $$
USE `faculdade`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `consulta_cursos`()
begin
    select *
    from Cursos;
end$$

DELIMITER ;
```

#### Como ficou a seleção:
![seleção](selecao.png)

