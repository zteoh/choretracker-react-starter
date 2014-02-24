## 67-272: ChoreTracker ##

This is a lab project for 67-272: Application Design and Development.  The primary objectives of this lab are (1) to give students experience doing test-driven development (TDD) and (2) reinforce concepts they have learned so far in class.  

Because it is intended for teaching TDD, the models in the system are minimal Rails models, but a unit-testing suite is provided along with working factories and contexts.  The application does have some basic working controllers and views, although we will tighten them up during the course of the lab as well.

To set this up, clone this repository, run the `bundle install` command to ensure you have all the needed gems and then create the database with `rake db:migrate`.  If you want to populate the development system with same testing data, you can load the factories and contexts into rails console and build them there. (You will need to specify the relationships before building the context for chores, but children and tasks can be done right away.) This was demo'd in class last week and we will work you through this later in the lab as well.

Instructions for how to complete the lab and fill in the missing components can be found in the lab instructions found on the [67-272 course site](http://cmu-is-272.org/labs/7).

**Qapla'**

**Prof. H**