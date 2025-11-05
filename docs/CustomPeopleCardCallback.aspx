<%@ Page Language="C#" %>

<%@ Register TagPrefix="ex" Namespace="Exact.Web.UI.Controls" Assembly="Exact.Web.UI.Controls" %>
<%@ Import Namespace="Exact.Data" %>
<%@ Import Namespace="Exact.Core" %>
<%@ Import Namespace="Exact.Common" %>
<%@ Import Namespace="Exact.Repository" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Web.Services" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="Newtonsoft.Json.Converters" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Threading.Tasks" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Globalization" %>

<html>
<script runat="server">

    private void Page_Init()
    {
        this.AppUserLicenseType = UserLicenseType.CRM;

        AppLog = true;
        IgnoreCallStack = true;

    }

    private void Page_Load()
    {
        try
        {
            var action = Convert.ToInt16(Action.Value);

            switch (action)
            {
                case 1:
                    {
                        // Get employees data
                        QueryBuilder qb = new QueryBuilder(conn);
                        qb.AppendSelect(@"
                            res_id employeeId, 
                            fullname employeeName, 
                            jt.descr50 jobTitle,
                            mail email, 
                            ldatindienst joinDate, 
                            Picture picture
                        ");
                        qb.AppendFrom("humres h");
                        qb.AppendFrom(JoinType.Inner, "hrjbtl jt", "h.job_title = jt.job_title");
                        qb.AppendWhere("res_id", Operators.GreaterThan, 0);

                        DataSet ds = (DataSet)conn.Query(qb, null, EDLQueryOptions.DataSet);
                        DataTable dt = ds.Tables[0];

                        var employees = new List<object>();
                        foreach (DataRow row in dt.Rows)
                        {
                            string pictureUrl = null;

                            // Convert byte[] to base64 data URI if picture exists
                            if (row["picture"] != DBNull.Value && row["picture"] != null)
                            {
                                byte[] imageBytes = row["picture"] as byte[];
                                if (imageBytes != null && imageBytes.Length > 0)
                                {
                                    string base64String = Convert.ToBase64String(imageBytes);
                                    pictureUrl = "data:image/jpeg;base64," + base64String;
                                }
                            }

                            employees.Add(new
                            {
                                employeeId = row["employeeId"],
                                employeeName = row["employeeName"],
                                jobTitle = row["jobTitle"],
                                email = row["email"],
                                joinDate = row["joinDate"] != DBNull.Value ? Convert.ToDateTime(row["joinDate"]).ToString("yyyy-MM-dd") : null,
                                picture = pictureUrl
                            });
                        }

                        WriteResponse(new { success = true, data = employees });
                        break;
                    }
                default:
                    WriteResponse(new { success = false, message = "Invalid action" }, 400);
                    break;
            }
        }
        catch (Exception ex)
        {
            WriteResponse(ex, 400);
        }
    }

    private void WriteResponse(object obj, int statusCode = 200)
    {
        var settings = new Newtonsoft.Json.JsonSerializerSettings
        {
            // Using explicit JsonProperty attributes on model classes instead of ContractResolver
            Formatting = Newtonsoft.Json.Formatting.None
        };
        Response.Clear();
        Response.ContentType = "application/json; charset=utf-8";
        Response.StatusCode = statusCode;
        Response.Write(Newtonsoft.Json.JsonConvert.SerializeObject(obj, settings));

        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.SuppressContent = true;
        HttpContext.Current.ApplicationInstance.CompleteRequest();
    }
</script>
<body>
    <ex:InputField runat="server" ID="Action" Visible="false" />
</body>
</html>