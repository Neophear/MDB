using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB
{
    public partial class missingapprovals : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string sp = "";

            if (e.CommandName == "Storage")
                sp = "SetOrderToStorage";
            else if (e.CommandName == "Approve")
                sp = "OrderApprove";

            if (sp != "")
            {
                DataAccessLayer dal = new DataAccessLayer();

                dal.AddParameter("@OrderId", e.CommandArgument, System.Data.DbType.Int32);
                dal.AddParameter("@Executor", User.Identity.Name, System.Data.DbType.String);
                dal.ExecuteStoredProcedure(sp);
                dal.ClearParameters();

                gvOrders.DataBind();
            }
        }

        protected void gvOrders_DataBound(object sender, EventArgs e)
        {
            lblRowCount.Text = $"{gvOrders.Rows.Count} ordrer";
        }
    }
}