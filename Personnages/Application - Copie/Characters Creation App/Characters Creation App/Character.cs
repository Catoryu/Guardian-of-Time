using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GuardianOfTime
{
    [Serializable]
    public class Character
    {
        #region attributes
        private LastName lastName;
        public LastName LastName { get { return lastName; } set { lastName = value; } }
        private string firstName;
        public string FirstName { get { return firstName; } set { firstName = value; } }
        private Hair hair;
        public Hair Hair { get { return hair; } set { hair = value; } }
        private string eyesColor;
        public string EyesColor { get { return eyesColor; } set { eyesColor = value; } }
        private Race race;
        public Race Race { get { return race; } set { race = value; } }
        private int height;
        public int Height { get { return height; } set { height = value; } }
        private TimeDate birth;
        public TimeDate Birth { get { return birth; } set { birth = value; } }
        private Timeline timeLine;
        public Timeline TimeLine { get { return timeLine; } set { timeLine = value; } }
        public List<Thing> Likes;
        public List<Thing> Unlikes;
        public List<string> Elements;
        public List<Power> Powers;
        public List<Activity> Activities;
        public List<BackStory> Backstory;
        public List<Weapon> Weapons;
        public Character Alternative;
        #endregion attributes

        #region special attributes
        //Updated is an attribute that says if values should be updated (manualy of course) to a .docx file
        private bool updated;
        public bool Updated { get { return updated; } set { updated = value; } }
        #endregion special attributes

        //Creates a null character
        public Character()
        {
            this.Updated = true;
        }

        //Creates a character without all the lists
        public Character(LastName LastName, string FirstName, Hair Hair, string EyesColor,Race Race, int Height,
            TimeDate DateOfBirth, Timeline TimeLine)
        {
            this.LastName = LastName;
            this.FirstName = FirstName;
            this.LastName.FirstNames.Add(FirstName);
            this.Hair = Hair;
            this.EyesColor = EyesColor;
            this.Race = Race;
            this.Height = Height;
            this.Birth = DateOfBirth;
            this.TimeLine = TimeLine;
            this.Likes = new List<Thing>();
            this.Unlikes = new List<Thing>();
            this.Elements = new List<string>();
            this.Powers = new List<Power>();
            this.Activities = new List<Activity>();
            this.Backstory = new List<BackStory>();
            this.Weapons = new List<Weapon>();
            this.Alternative = null;
            this.Updated = true;
        }

        //Creates a complete character.
        public Character(LastName LastName, string FirstName, Hair Hair, string EyesColor, Race Race, int Height,
            TimeDate DateOfBirth, Timeline Timeline, List<Thing> Likes, List<Thing> Unlikes, List<string> Elements,
            List<Power> Powers, List<Activity> Activities, List<BackStory> Backstory, List<Weapon> Weapons,
            Character BaseCharacter)
        {
            this.LastName = LastName;
            this.FirstName = FirstName;
            this.Hair = Hair;
            this.EyesColor = EyesColor;
            this.Race = Race;
            this.Height = Height;
            this.Birth = DateOfBirth;
            this.TimeLine = TimeLine;
            this.Likes = Likes;
            this.Unlikes = Unlikes;
            this.Elements = Elements;
            this.Powers = Powers;
            this.Activities = Activities;
            this.Backstory = Backstory;
            this.Weapons = Weapons;
            this.Alternative = BaseCharacter;
            this.Updated = true;
        }

        #region public methods
        /// <summary>
        /// Sets the update state to false if update on .docx was needed.
        /// </summary>
        /// <returns>was Update needed ?</returns>
        public bool Update()
        {
            if (this.Updated)
            {
                this.Updated = false;
                return true;
            } else
            {
                return false;
            }
        }
        #endregion public methods
    }
}
