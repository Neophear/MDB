using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MDB.AppCode;

namespace MDB.Controls
{
    [ParseChildren(true, "Content")]
    [PersistChildren(false)]
    public partial class HoverMenu : System.Web.UI.UserControl
    {
        public bool Enabled = true;
        public string TargetControlID
        {
            get { return hme.TargetControlID; }
            set { hme.TargetControlID = value; }
        }

        public string Title
        {
            get { return lblTitle.Text; }
            set { lblTitle.Text = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            phContent.Controls.Add((Control)_content);
        }

        private Control _content;

        [PersistenceMode(PersistenceMode.InnerProperty)]
        public Control Content { get { return _content; } set { _content = value; } }
    }
}