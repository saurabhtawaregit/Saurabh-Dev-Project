public class JiraUserWrapper {

   public String self;
    public String accountId;
    public String accountType;
    public String emailAddress;
    
    public static List<JiraUserWrapper> parse(String json) {
      return (List<JiraUserWrapper>) System.JSON.deserialize(json, List<JiraUserWrapper>.class);
    }
  
}