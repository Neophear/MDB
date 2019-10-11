using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.Controls
{
    public partial class HoverDetails : System.Web.UI.UserControl
    {
        public string Text
        {
            get { return lbl.Text; }
            set { lbl.Text = value; }
        }

        public string TextFull
        {
            get { return lblFull.Text; }
            set { lblFull.Text = value; }
        }


        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}