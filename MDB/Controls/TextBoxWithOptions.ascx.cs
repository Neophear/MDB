using MDB.AppCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.Controls
{
    public partial class TextBoxWithOptions : System.Web.UI.UserControl
    {
        public string Text { get => txt.Text; }
        public bool PreferInput { get => _preferInput; set => _preferInput = value; }
        private bool _preferInput = false;
        public MusterLine.MusterLinePart LinePart;

        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}