import xml.etree.ElementTree as et
import gen3_spark.settings as config


CONFIG_PATH = '{}/etc/hadoop/'.format(config.HADOOP_HOME)


def indent(elem, level=0):
    i = "\n" + level*"  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
    if not elem.tail or not elem.tail.strip():
        elem.tail = i
    for elem in elem:
        indent(elem, level+1)
    if not elem.tail or not elem.tail.strip():
        elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i


def configure_core_site():
    core_site_path = '{}core-site.xml'.format(CONFIG_PATH)
    tree = et.parse(core_site_path)
    root = tree.getroot()
    root.append(create_property('hadoop.tmp.dir', '{}/hdfs/tmp'.format(config.HADOOP_HOME)))
    root.append(create_property('fs.default.name', config.HADOOP_URL))
    indent(root)
    tree.write(core_site_path)


def configure_hdfs_site():
    core_site_path = '{}hdfs-site.xml'.format(CONFIG_PATH)
    tree = et.parse(core_site_path)
    root = tree.getroot()
    root.append(create_property('dfs.blocksize', '268435456'))
    root.append(create_property('dfs.hosts', ''))
    root.append(create_property('dfs.namenode.handler.count', '100'))
    root.append(create_property('dfs.namenode.name.dir', '/hadoop/hdfs/data/dfs/namenode'))
    root.append(create_property('dfs.namenode.data.dir', '/hadoop/hdfs/data/dfs/datanode'))
    root.append(create_property('dfs.namenode.http-bind-host', config.HADOOP_HOST))
    root.append(create_property('dfs.namenode.https-bind-host', config.HADOOP_HOST))
    root.append(create_property('dfs.client.use.datanode.hostname', 'true'))
    root.append(create_property('dfs.datanode.use.datanode.hostname', 'true'))
    root.append(create_property('dfs.permissions', 'false'))
    indent(root)
    tree.write(core_site_path)


def configure_yarn_site():
    core_site_path = '{}yarn-site.xml'.format(CONFIG_PATH)
    tree = et.parse(core_site_path)
    root = tree.getroot()
    root.append(create_property('yarn.nodemanager.aux-services', 'mapreduce_shuffle'))
    root.append(create_property('yarn.resourcemanager.scheduler.address', '{}:8030'.format(config.HADOOP_HOST)))
    root.append(create_property('yarn.resourcemanager.resource-tracker.address', '{}:8031'.format(config.HADOOP_HOST)))
    root.append(create_property('yarn.resourcemanager.address', '{}:8032'.format(config.HADOOP_HOST)))
    tree.write(core_site_path)


def configure_mapred_site():
    core_site_path = '{}mapred-site.xml'.format(CONFIG_PATH)
    tree = et.parse(core_site_path)
    root = tree.getroot()
    root.append(create_property('mapreduce.framework.name', 'yarn'))
    root.append(create_property('mapreduce.application.classpath',
                                '$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:'
                                '$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*'))
    indent(root)
    tree.write(core_site_path)


def create_property(prop_name, prop_val):
    prop = et.Element('property')
    name = et.Element('name')
    name.text = prop_name
    value = et.Element('value')
    value.text = prop_val
    prop.append(name)
    prop.append(value)
    return prop


if __name__ == '__main__':
    configure_core_site()
    configure_hdfs_site()
    configure_mapred_site()
