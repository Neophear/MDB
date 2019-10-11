using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.Controls
{
    public partial class ShowLog : System.Web.UI.UserControl
    {
        private int _objectTypeId;
        private int _objectId;

        public int ObjectTypeId
        {
            get
            {
                if (ViewState["ObjectTypeId"] != null)
                    _objectTypeId = Int32.Parse(ViewState["ObjectTypeId"].ToString());
                return _objectTypeId;
            }
            set { ViewState["ObjectTypeId"] = value; }
        }

        public int ObjectId
        {
            get
            {
                if (ViewState["ObjectId"] != null)
                    _objectId = Int32.Parse(ViewState["ObjectId"].ToString());
                return _objectId;
            }
            set { ViewState["ObjectId"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void sdsLog_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            if (ObjectTypeId > 0)
                e.Command.Parameters["@ObjectTypeId"].Value = ObjectTypeId;

            if (ObjectId > 0)
                e.Command.Parameters["@ObjectId"].Value = ObjectId;
        }

        protected void gvLog_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (ObjectTypeId == 2 && e.Row.RowType == DataControlRowType.DataRow)
            {
                if ((int)DataBinder.Eval(e.Row.DataItem, "ObjectTypeId") == 5)
                {
                    int Id = (int)DataBinder.Eval(e.Row.DataItem, "ObjectId");
                    string Location = ResolveUrl("~/order/") + Id;
                    e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                    //e.Row.Attributes["onClick"] = $"javascript:window.location='{Location}';";
                    e.Row.Style["cursor"] = "pointer";
                }
            }
        }
    }
}