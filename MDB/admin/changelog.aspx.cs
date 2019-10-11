using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.admin
{
    public partial class changelog : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void gvChangeLog_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvChangeLog.ChangeMode(DetailsViewMode.Edit);
        }
        protected void dvChangeLog_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            gvChangeLog.DataBind();
        }
        protected void dvChangeLog_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            gvChangeLog.DataBind();
        }

        protected void sdsWriteChangeLog_Changing(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Executor"].Value = User.Identity.Name;
        }
    }
}