using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using MDB.AppCode;

namespace MDB.admin
{
    public partial class users : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                gvUsers.DataSource = MDBUser.GetAllUsers();
                gvUsers.DataBind();
            }
        }

        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string username = DataBinder.Eval(e.Row.DataItem, "UserName").ToString();
                string Location = ResolveUrl($"~/admin/user/{username}");
                e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                //e.Row.Attributes["onClick"] = $"javascript:window.location='{Location}';";
                e.Row.Style["cursor"] = "pointer";
            }
        }
        public SortDirection GridViewSortDirection
        {
            get
            {
                if (ViewState["sortDirection"] == null)
                    ViewState["sortDirection"] = SortDirection.Ascending;

                return (SortDirection)ViewState["sortDirection"];
            }
            set { ViewState["sortDirection"] = value; }
        }
        protected void gvUsers_Sorting(object sender, GridViewSortEventArgs e)
        {
            //re-run the query, use linq to sort the objects based on the arg.
            //perform a search using the constraints given 
            //you could have this saved in Session, rather than requerying your datastore
            List<MDBUser> users = MDBUser.GetAllUsers();

            if (users != null)
            {
                var param = Expression.Parameter(typeof(MDBUser), e.SortExpression);
                var sortExpression = Expression.Lambda<Func<MDBUser, object>>(Expression.Convert(Expression.Property(param, e.SortExpression), typeof(object)), param);

                if (GridViewSortDirection == SortDirection.Ascending)
                {
                    gvUsers.DataSource = users.AsQueryable<MDBUser>().OrderBy(sortExpression);
                    GridViewSortDirection = SortDirection.Descending;
                }
                else
                {
                    gvUsers.DataSource = users.AsQueryable<MDBUser>().OrderByDescending(sortExpression);
                    GridViewSortDirection = SortDirection.Ascending;
                }

                gvUsers.DataBind();
            }
        }
    }
}