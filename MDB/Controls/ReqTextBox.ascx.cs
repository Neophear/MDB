using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

[assembly: TagPrefix("MDB.Controls", "MDB")]

namespace MDB.Controls
{
    public partial class ReqTextBox : UserControl
    {
        public string PropertyText;
        public int MinLength = 0;
        public string Text
        {
            get { return txt.Text; }
            set { txt.Text = value; }
        }
        private string _validationGroup;
        public string ValidationGroup
        {
            get { return _validationGroup; }
            set { _validationGroup = txt.ValidationGroup = re.ValidationGroup = rfv.ValidationGroup = value; }
        }
        public int MaxLength
        {
            get { return txt.MaxLength; }
            set { txt.MaxLength = value; }
        }

        private AppCode.Functions.ObjectType _checkIfExists = 0;
        public AppCode.Functions.ObjectType CheckIfExists
        {
            get { return _checkIfExists; }
            set { _checkIfExists = value; }
        }

        public string ServiceMethod
        {
            get { return ace.ServiceMethod; }
            set { ace.ServiceMethod = value; }
        }

        public void AddAttribute(string key, string value)
        {
            txt.Attributes.Add(key, value);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            re.ErrorMessage = rfv.ErrorMessage = $"{PropertyText} skal være på mellem {MinLength} og {MaxLength} karakterer.";
            re.ValidationExpression = $".{{{MinLength},{MaxLength}}}";
            ace.Enabled = !String.IsNullOrWhiteSpace(ace.ServiceMethod);

            if (_checkIfExists > 0)
                txt.Attributes["OnBlur"] = $"ShowAvailability(this,{(int)_checkIfExists})";
        }
    }
}