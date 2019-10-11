using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB.admin
{
    public partial class news : System.Web.UI.Page
    {
        protected bool Sticky;
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void sdsNews_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            string id = Page.RouteData.Values["id"].ToString();

            if (!String.IsNullOrWhiteSpace(id))
            {
                e.Command.Parameters["@Id"].Value = id;
                ChangeMode(DetailsViewMode.Edit);
            }
            else
                ChangeMode(DetailsViewMode.Insert);
        }

        protected void sdsNews_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (Page.RouteData.Values["id"].ToString() != "")
            {
                if (e.AffectedRows == 1)
                    ChangeMode(DetailsViewMode.Edit);
                else
                    Response.Redirect("~/admin/news");
            }
            else
                ChangeMode(DetailsViewMode.Insert);
        }

        protected void ChangeMode(DetailsViewMode mode)
        {
            dvNews.ChangeMode(mode);
            pnlShow.Visible = mode == DetailsViewMode.Edit;
        }

        protected void sdsNews_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            Response.Redirect("~/");
        }

        protected void sdsNews_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            dvNews.DataBind();
            UpdateExample();
        }

        protected void sdsNews_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            Response.Redirect($"~/admin/news/{e.Command.Parameters["@LastId"].Value}");
        }

        protected void dvNews_DataBound(object sender, EventArgs e)
        {
            if (dvNews.DataItemCount == 1)
                UpdateExample();
        }

        private void UpdateExample()
        {
            Sticky = (bool)DataBinder.Eval(dvNews.DataItem, "Sticky");
            lblTitle.Text = DataBinder.Eval(dvNews.DataItem, "Title").ToString();
            lblContent.Text = Utilities.BBToHTML(DataBinder.Eval(dvNews.DataItem, "Content").ToString());
            lblTimeStamp.Text = Utilities.GetFriendlyTime((DateTime)DataBinder.Eval(dvNews.DataItem, "Timestamp"));
        }

        protected void dvNews_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            e.NewValues["Content"] = Utilities.StripHTML(e.NewValues["Content"].ToString());
        }

        protected void dvNews_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            e.Values["Content"] = Utilities.StripHTML(e.Values["Content"].ToString());
        }

        protected void sdsNews_Changing(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Executor"].Value = User.Identity.Name;
        }

        protected void lnkbtnShowExample_Click(object sender, EventArgs e)
        {
            Sticky = ((CheckBox)dvNews.FindControl("chkbxSticky")).Checked;
            lblTitle.Text = ((TextBox)dvNews.FindControl("txtTitle")).Text;
            lblContent.Text = Utilities.BBToHTML(((Controls.AdvancedTextBox)dvNews.FindControl("advtxtContent")).Text);
            lblTimeStamp.Text = Utilities.GetFriendlyTime(DateTime.Now);
            pnlShow.Visible = true;
        }
    }
}