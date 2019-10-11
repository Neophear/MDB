using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.Controls
{
    public partial class Comments : System.Web.UI.UserControl
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

        protected void sdsComments_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.Parameters["@ObjectTypeRefId"].Value = ObjectTypeId;
            e.Command.Parameters["@ObjectRefId"].Value = ObjectId;
        }

        protected void sdsComments_Inserting(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Executor"].Value = Membership.GetUser().UserName;
            e.Command.Parameters["@ObjectTypeRefId"].Value = ObjectTypeId;
            e.Command.Parameters["@ObjectRefId"].Value = ObjectId;
        }

        protected void lnkbtnDelete_Click(object sender, EventArgs e)
        {
            sdsComments.DeleteParameters["Id"].DefaultValue = ((LinkButton)sender).CommandArgument;
            sdsComments.DeleteParameters["Executor"].DefaultValue = Membership.GetUser().UserName;
            sdsComments.Delete();
        }

        protected void cvText_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = args.Value != "";
        }
    }
}