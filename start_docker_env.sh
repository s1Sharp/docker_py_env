docker run -i -d --privileged=true -v E:/Code/kts/code:/code -p 3000:3000 -p 5000:5000 -p 8080:80 -p 8848:8848 -p 5432:5432 s1sharp/kts:latest