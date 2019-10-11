using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB
{
    public partial class settings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ChangePassword1_ChangedPassword(object sender, EventArgs e)
        {
            DataAccessLayer dal = new DataAccessLayer();
            dal.AddParameter("@Username", User.Identity.Name, System.Data.DbType.String);
            dal.AddParameter("@Executor", User.Identity.Name, System.Data.DbType.String);
            dal.AddParameter("@Unlock", false, System.Data.DbType.Boolean);
            dal.ExecuteStoredProcedure("UserChangedPassword");
            dal.ClearParameters();
        }
    }
}