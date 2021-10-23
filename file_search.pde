import java.util.regex.Pattern;
void setup() {
  size(200,200);
  String root = search("E:/ProgramingFolder","file_......");    // enter file name as 2nd args
  if (root != null) {
    println(root);
    // save to XML
    String xmlString = toXML(root);
    XML xml = parseXML(xmlString);
    saveXML(xml, "save.xml");
    // search from XML
    XML saveXML = loadXML("save.xml");
    ArrayList<String> file = searchXML(saveXML,"^hello.{0,}");
    println(file);
  }
  else {
    println("Can't find file/folder");
  }
  
}
String search(String rootPath, String fileName) {
  /**
  * @param rootPath search location
  * @param fileName search file name
  */
  File f = new File(rootPath);
  File[] files = f.listFiles();
  if (files != null && files.length > 0) {             // folder isn't empty
    for (File file : files) {
      if (Pattern.matches(fileName, file.getName())) {           // found file
        println("\n\n\n\n\nFound. \n");
        String path = rootPath+"/"+file.getName();
        return path;
      }
      if (file.isDirectory()) {                        
        println("Processing in "+file.getAbsolutePath());
        String path = search(file.getAbsolutePath(),fileName);       // traverse
        if (path != null) {
          return path;
        }
      }
    }
  }
  return null;
}
String toXML(String path) {
  File f = new File(path);
  String root = "<folder name="+'"'+f.getName()+'"'+'>';
  File[] files = f.listFiles();
  if (files != null && files.length > 0) {
    for (File file : files) {
      if (!file.isDirectory()) { 
        String fileTag = "<file>" + file.getName() + "</file>";
        root += fileTag;
      }
      else {
        root += toXML(file.getAbsolutePath());
      }
    }
  }
  root += "</folder>";
  return root;
}
ArrayList<String> searchXML(XML xml,String regex) {
  /**
  * @param xml
  * @param regex
  */
  ArrayList<String> found = new ArrayList<String>();
  XML[] filesXML = xml.getChildren("file");
  XML[] folderXML = xml.getChildren("folder");
  for (XML fileXML : filesXML) {
    if (Pattern.matches(regex,fileXML.getContent())) {
      String f = xml.getString("name") + '/' + fileXML.getContent();
      found.add(f);
    }
  }
  for (XML folder : folderXML) {
    if (Pattern.matches(regex,folder.getString("name"))) {
      String f = xml.getString("name") + '/' + folder.getString("name");;
      found.add(f); 
    }
    ArrayList<String> path = searchXML(folder,regex);
    for (String p:path) {
      p = xml.getString("name") + '/' + p;
      found.add(p);
    }
  }
  return found;
}
