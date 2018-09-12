import os

try:
    # Import everything from ``local_settings``, if it exists.
    from gen3_spark.local_settings import *
except ImportError:
    # If it doesn't, look in ``/var/www/tube``.
    try:
        import imp
        imp.load_source('local_settings', '/gen3-spark/gen3_spark/local_settings.py')
        print('finished importing')
    except IOError:
        HADOOP_HOME = os.getenv("HADOOP_HOME", "")
        JAVA_HOME = os.getenv("JAVA_HOME", "")
        HADOOP_URL = os.getenv("HADOOP_URL", "")
        HADOOP_HOST = os.getenv("HADOOP_HOST", "spark")