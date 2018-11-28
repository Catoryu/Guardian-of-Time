namespace GuardianOfTime
{
    partial class ListForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.ListTable = new System.Windows.Forms.ListView();
            this.ChoiceBox1 = new System.Windows.Forms.ComboBox();
            this.ChoiceBox2 = new System.Windows.Forms.ComboBox();
            this.ChoiceBox3 = new System.Windows.Forms.ComboBox();
            this.ChoiceBox4 = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // ListTable
            // 
            this.ListTable.FullRowSelect = true;
            this.ListTable.GridLines = true;
            this.ListTable.LabelWrap = false;
            this.ListTable.Location = new System.Drawing.Point(25, 50);
            this.ListTable.MultiSelect = false;
            this.ListTable.Name = "ListTable";
            this.ListTable.Size = new System.Drawing.Size(775, 500);
            this.ListTable.TabIndex = 0;
            this.ListTable.UseCompatibleStateImageBehavior = false;
            this.ListTable.View = System.Windows.Forms.View.Details;
            // 
            // ChoiceBox1
            // 
            this.ChoiceBox1.FormattingEnabled = true;
            this.ChoiceBox1.Location = new System.Drawing.Point(25, 25);
            this.ChoiceBox1.Name = "ChoiceBox1";
            this.ChoiceBox1.Size = new System.Drawing.Size(175, 21);
            this.ChoiceBox1.TabIndex = 1;
            this.ChoiceBox1.SelectedIndexChanged += new System.EventHandler(this.ChoiceBox1_SelectedIndexChanged);
            // 
            // ChoiceBox2
            // 
            this.ChoiceBox2.FormattingEnabled = true;
            this.ChoiceBox2.Location = new System.Drawing.Point(225, 25);
            this.ChoiceBox2.Name = "ChoiceBox2";
            this.ChoiceBox2.Size = new System.Drawing.Size(175, 21);
            this.ChoiceBox2.TabIndex = 2;
            this.ChoiceBox2.SelectedIndexChanged += new System.EventHandler(this.ChoiceBox2_SelectedIndexChanged);
            // 
            // ChoiceBox3
            // 
            this.ChoiceBox3.FormattingEnabled = true;
            this.ChoiceBox3.Location = new System.Drawing.Point(425, 25);
            this.ChoiceBox3.Name = "ChoiceBox3";
            this.ChoiceBox3.Size = new System.Drawing.Size(175, 21);
            this.ChoiceBox3.TabIndex = 3;
            this.ChoiceBox3.SelectedIndexChanged += new System.EventHandler(this.ChoiceBox3_SelectedIndexChanged);
            // 
            // ChoiceBox4
            // 
            this.ChoiceBox4.FormattingEnabled = true;
            this.ChoiceBox4.Location = new System.Drawing.Point(625, 25);
            this.ChoiceBox4.Name = "ChoiceBox4";
            this.ChoiceBox4.Size = new System.Drawing.Size(175, 21);
            this.ChoiceBox4.TabIndex = 4;
            this.ChoiceBox4.SelectedIndexChanged += new System.EventHandler(this.ChoiceBox4_SelectedIndexChanged);
            // 
            // ListForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(959, 561);
            this.Controls.Add(this.ChoiceBox4);
            this.Controls.Add(this.ChoiceBox3);
            this.Controls.Add(this.ChoiceBox2);
            this.Controls.Add(this.ChoiceBox1);
            this.Controls.Add(this.ListTable);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "ListForm";
            this.Text = "List App";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListView ListTable;
        private System.Windows.Forms.ComboBox ChoiceBox1;
        private System.Windows.Forms.ComboBox ChoiceBox2;
        private System.Windows.Forms.ComboBox ChoiceBox3;
        private System.Windows.Forms.ComboBox ChoiceBox4;
    }
}