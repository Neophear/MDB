using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            pnlLoggedIn.Visible = Page.User.Identity.IsAuthenticated;

            txtSearch.Focus();

            //Update LastActivityDate on current user
            try
            {
                System.Web.Security.Membership.GetUser();
            }
            catch (Exception)
            {

            }            
            
            //Green BG if localhost (to make it clear if debugging or not)
            //if (Request.Url.Host == "localhost")
            //    body.Style.Add("background-color", "lightgreen");

            hdlnkCDD.Href = $"~/Content/StyleSheet.css?d={File.GetLastWriteTime(Server.MapPath("~/Content/StyleSheet.css")).ToString("yyyyMMddHHmm")}";
            scriptmngr.Scripts.Add(new ScriptReference($"~/Scripts/mdbscripts.js?v={File.GetLastWriteTime(Server.MapPath("~/Scripts/mdbscripts.js")):yyyyMMddHHmm}"));
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string strSearch = txtSearch.Text.Trim();

            DataAccessLayer dal = new DataAccessLayer();
            dal.AddParameter("@searchString", strSearch, DbType.String);
            DataTable dt = dal.ExecuteDataTable("EXEC dbo.Search @searchString");
            dal.ClearParameters();

            if (dt.Rows.Count == 1)
            {
                switch ((int)dt.Rows[0][0])
                {
                    case 2:
                        Response.Redirect($"~/employee/{dt.Rows[0][1]}");
                        break;
                    case 3:
                        Response.Redirect($"~/device/{dt.Rows[0][1]}");
                        break;
                    case 4:
                        Response.Redirect($"~/simcard/{dt.Rows[0][1]}");
                        break;
                    default:
                        break;
                }
            }
            else
                Response.Redirect($"~/search/{strSearch}");
        }
    }
}