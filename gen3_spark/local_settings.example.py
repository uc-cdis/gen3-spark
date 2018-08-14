import os

HADOOP_HOME = os.getenv("HADOOP_HOME", "/usr/local/Cellar/hadoop/3.1.0/libexec/")
JAVA_HOME = os.getenv("JAVA_HOME", "/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home")
HADOOP_URL = os.getenv("HADOOP_URL", "hdfs://localhost:9000")
HADOOP_HOST = os.getenv("HADOOP_HOST", "spark")
