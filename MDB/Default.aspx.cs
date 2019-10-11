using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using MDB.AppCode;
using Stiig;

namespace MDB
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void sdsNews_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            dpNews.Visible = !(e.AffectedRows <= 5);
        }

        protected void sdsNews_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.Parameters["@Role"].Value = Roles.GetRolesForUser()[0];
        }

        protected void sdsChangeLog_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.Parameters["@Role"].Value = Roles.GetRolesForUser()[0];
        }
    }
}