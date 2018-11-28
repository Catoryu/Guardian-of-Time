using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GuardianOfTime
{
    public class World
    {
        public static int PeopleMinHeight = 100;
        public static int PeopleMaxHeight = 221;
        public static int GodMinHeight = 240;
        public static int GodMaxHeight = 260;

        public List<string> Elements;
        public List<string> DragonNames;

        //Creates a simple World
        public World()
        {
            Elements = new List<string>();
            Elements.Add("Feu");
            Elements.Add("Glace");
            Elements.Add("Eau");
            Elements.Add("Terre");
            Elements.Add("Vent");
            Elements.Add("Foudre");
            Elements.Add("Lumière");
            Elements.Add("Ténèbres");

            DragonNames = new List<string>();
            DragonNames.Add("Embos");
            DragonNames.Add("Nezier");
            DragonNames.Add("Roldreog");
            DragonNames.Add("Yrdod");
            DragonNames.Add("Tyvurair");
            DragonNames.Add("Todranyr");
            DragonNames.Add("Surleoth");
            DragonNames.Add("Tierioth");
            DragonNames.Add("Dozenainth");
            DragonNames.Add("Biosudeig");
            DragonNames.Add("Tudhointh");
            DragonNames.Add("Noirreod");
            DragonNames.Add("Rurmeor");
            DragonNames.Add("Bulluphuth");
            DragonNames.Add("Freillaer");
            DragonNames.Add("Froimmir");
            DragonNames.Add("Gaildriarth");
            DragonNames.Add("Zundraeg");
            DragonNames.Add("Bogalth");
            DragonNames.Add("Rymrog");
            DragonNames.Add("Yllaephae");
            DragonNames.Add("Tythiessal");
            DragonNames.Add("Yzzur");
            DragonNames.Add("Xeotu");
            DragonNames.Add("Chormois");
            DragonNames.Add("Sephaideolth");
            DragonNames.Add("Soildrulus");
            DragonNames.Add("Vaeldrierth");
            DragonNames.Add("Oagul");
            DragonNames.Add("Nursyrth");
            DragonNames.Add("Uvrulun");
            DragonNames.Add("Burlelor");
            DragonNames.Add("Dorvess");
            DragonNames.Add("Grandrorth");
        }
    }

    [Serializable]
    public struct LastName
    {
        public string Name;
        public Race Race;
        public List<string> FirstNames;

        public LastName(string Name, Race Race)
        {
            this.Name = Name;
            this.Race = Race;
            this.FirstNames = new List<string>();
        }
    }

    [Serializable]
    public struct Race
    {
        public string Name;

        public Race(string Name)
        {
            this.Name = Name;
        }
    }

    [Serializable]
    public struct Hair
    {
        public string Color;
        public string Length;

        public Hair(string Color, string Length)
        {
            this.Color = Color;
            this.Length = Length;
        }
    }

    [Serializable]
    public struct Timeline
    {
        public string Name;
        public TimeDate MainDate;

        public Timeline(string Name, TimeDate MainDate)
        {
            this.Name = Name;
            this.MainDate = MainDate;

        }
    }

    [Serializable]
    public struct Thing
    {
        public string Name;

        public Thing(string Name)
        {
            this.Name = Name;
        }
    }

    [Serializable]
    public struct Power
    {
        public string Name;

        public Power(string Name)
        {
            this.Name = Name;

        }
    }

    [Serializable]
    public struct Activity
    {
        public string Title;
        public Timeline Timeline;

        public Activity(string Title, Timeline Timeline)
        {
            this.Title = Title;
            this.Timeline = Timeline;
        }
    }

    [Serializable]
    public struct BackStory
    {
        public string Title;
        public string Story;
        public Timeline Timeline;

        public BackStory(string Title, string Story, Timeline Timeline)
        {
            this.Title = Title;
            this.Story = Story;
            this.Timeline = Timeline;
        }
    }

    [Serializable]
    public struct Weapon
    {
        public string Name;
        public string Element;
        public bool Special;

        public Weapon(string Name)
        {
            this.Name = Name;
            this.Element = null;
            this.Special = false;
        }

        public Weapon(string Name, bool Special)
        {
            this.Name = Name;
            this.Element = null;
            this.Special = Special;
        }

        public Weapon(string Name, bool Special, string Element)
        {
            this.Name = Name;
            this.Element = Element;
            this.Special = Special;
        }
    }

    [Serializable]
    public class TimeDate
    {
        private int day;
        private int month;
        private int year;
        public int Day {
            get { return day; }
            set
            {
                if (value < 1) throw new ArgumentOutOfRangeException();
                switch(month)
                {
                    case 1:
                    case 3:
                    case 5:
                    case 7:
                    case 8:
                    case 10:
                    case 12:
                        if (value > 31) throw new ArgumentOutOfRangeException();
                        break;
                    case 4:
                    case 6:
                    case 9:
                    case 11:
                        if (value > 30) throw new ArgumentOutOfRangeException();
                        break;
                    case 2:
                        if (year % 4 == 0)
                        {
                            if (value > 29) throw new ArgumentOutOfRangeException();
                        }
                        else
                        {
                            if (value > 28) throw new ArgumentOutOfRangeException();
                        }
                        break;
                    default:
                        throw new Exception();
                }
                day = value;
            }
        }
        public int Month {
            get { return month; }
            set {
                if (value < 1 || value > 12) throw new ArgumentOutOfRangeException();
                month = value;
            }
        }
        public int Year
        {
            get { return year; }
            set
            {
                year = value;
            }
        }

        public TimeDate(int Year, int Month, int Day)
        {
            this.Year = Year;
            this.Month = Month;
            this.Day = Day;
        }
    }
}
