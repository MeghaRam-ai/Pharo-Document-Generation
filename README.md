This program takes a Pharo package and generates the equivalent of the Java doc for each of the classes in the container. 
For each class, we will have its superclass, its subclasses, its instance variables, and its methods with possible comments.

This project integrates with the Seaside web framework.


### To run the project: 

```
DocumentationGenerator initialize .
```

You can see the webpage in http://localhost:8080/documentation



#### Note: Seaside will have been already installed with Pharo, if not excecute:

```
  Metacello new
  baseline:'Seaside3';
  repository: 'github://SeasideSt/Seaside:master/repository';
  load
```


### Preview: 

<img width="1000" alt="image" src="https://github.com/user-attachments/assets/77ffd13f-9f12-40f1-91d1-93e64fa46ed6" />

<img width="1000" alt="image" src="https://github.com/user-attachments/assets/bceefec0-6459-48da-9362-568524cdad49" />

