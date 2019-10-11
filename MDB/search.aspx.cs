using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB
{
    public partial class search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void gvSearch_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string site = "";

                switch ((int)DataBinder.Eval(e.Row.DataItem, "TypeId"))
                {
                    case 2:
                        site = "employee";
                        break;
                    case 3:
                        site = "device";
                        break;
                    case 4:
                        site = "simcard";
                        break;
                    default:
                        break;
                }

                string Location = ResolveUrl($"~/{site}/{DataBinder.Eval(e.Row.DataItem, "Id")}");
                e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                //e.Row.Attributes["onClick"] = $"javascript:window.location='{Location}';";
                e.Row.Style["cursor"] = "pointer";
            }
        }
    }
}