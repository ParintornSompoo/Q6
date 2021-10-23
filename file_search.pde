import java.util.regex.Matcher;
import java.util.regex.Pattern;
void setup() {
  size(200,200);
  String root = search("/home","VS Code Workspace");    // enter file name as 2nd args
  if (root != null) {
    println(root);
    // save to XML
    String xmlString = toXML(root);
    XML xml = parseXML(xmlString);
    saveXML(xml, "save.xml");
    // setup regex
    Pattern p = Pattern.compile("x.");
    
    // search from XML
    XML saveXML = loadXML("save.xml");
    String file = searchXML(saveXML,"hello");
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
      if (file.getName().equals(fileName)) {           // found file
        String path = rootPath+"/"+fileName;
        return path;
      }
      if (file.isDirectory()) {                        
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
String searchXML(XML xml,String file) {
  XML[] filesXML = xml.getChildren("file");
  XML[] folderXML = xml.getChildren("folder");
  for (XML fileXML : filesXML) {
    if (fileXML.getContent().equals(file)) {
      return xml.getString("name") + '/' + file;
    }
  }
  for (XML folder : folderXML) {
    if (folder.getString("name").equals(file)) {
      return xml.getString("name") + '/' + file;
    }
    String path = searchXML(folder,file);
    if (path != null) {
      return xml.getString("name") + '/' + path;
    }
  }
  return null;
}
