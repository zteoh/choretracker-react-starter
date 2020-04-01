# ChoreTracker UX Improvements with React.js #

# Part 1: Setup and Installation #

1. Clone starter code `git clone https://github.com/zteoh/choretracker-react-starter.git`

2. In your gemfile, add: `gem 'react-rails'` and `gem 'webpacker'` to the end of the file, not in any specific group

3. Run
    ```
    bundle install
    rails webpacker:install
    rails webpacker:install:react
    rails generate react:install
    ```

    This will add the following files to the application
    ```
    create  app/javascript/components
    create  app/javascript/components/.keep
    create  app/javascript/packs/application.js
    create  app/javascript/packs/server_rendering.js
    ```
4. Link the JavaScript pack in Rails view by adding the following line between the `<head>` tags in `application.html.erb`
    ```
    <%= javascript_pack_tag 'application' %>
    ```
5. Generate a `Chores` Component
    ```
    rails g react:component Chores
    ```
    This would create the `Chores.js` file in  `app/javascript/components` and you should see the following:
    ```
    create  app/javascript/components/Chores.js
    ```
6. Connect the newly created `Chores` Component to your View (`app/views/chores/index.html`) above the `<table>` tag.
    ```
    <%= react_component("Chores") %>
    ```

7. Run `rails db:migrate` and then go to `rails console` to load the testing contexts (for children, tasks, and chores) as some base data. Remember this can be done in rails console through first requiring needed modules:

    ```
    require 'factory_bot_rails'
    require './test/contexts'
    include Contexts
    ```

    and then including the contexts:

    ```
    create_children
    create_tasks
    create_chores
    ```

8. You should see some records added to your database. Once you have some records, run `rails server` and check to see Chore Tracker is running properly in your browser. Also check the javascript console in the browser and make sure there are no errors. Ask a TA if you are not sure how to open the javascript console in your browser.

9. If you are using Google Chrome and have not done so, install the [React.JS DevTools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en), as it allows for properly checking components and their state, in real-time.

    Open the React DevTools and make sure that you are able to see the `Chores` component we just created.

    ![Chores component in React DevTools](https://i.imgur.com/gQPKain.png)

# Part 2: Displaying Chores #

## Verifying connection between the `Chore` Component and Rails View

1. Open the `Chores.js` file we just created and *replace* the `render()` function with a skeleton of the table

    ```
    render () {
        return (
            <div>
                <table>
                    <thead>
                        <tr>
                            <th width="125" align="left">Child</th>
                            <th width="200" align="left">Task</th>
                            <th width="75">Due on</th>
                            <th width="125">Completed</th>
                        </tr>
                    </thead>
                </table>
                <button>New Chore</button>
            </div>
        );
    }
    ```

2. Start your server and make sure you can see the header of the table

    ![Table Header](https://i.imgur.com/g32Zavs.png)

## Get information (like child name, task name and and chore information) to populate the table

3. Create `chores` variable in the state. Add the following statement and method in the `Chores` class.

    ```
    state = { 
        chores: [],
    }

    componentDidMount() {
        this.get_chores()
    }
    ```

    Create high level functions to obtain information about chores.

    ```
    get_chores = () => {
        this.run_ajax('/chores.json', 'GET', {}, (res) => {this.setState({chores: res})});
    }
    ```

4. Create function to make ajax requests. 

    ```
    run_ajax = (link, method="GET", data={}, callback = () => {this.get_chores()}) => {
        let options
        if (method == "GET") {
            options = { method: method}
        } else {
            options = { 
                method: method,
                body: JSON.stringify(data),
                headers: {
                'Content-Type': 'application/json',
                },
                credentials: 'same-origin'
            }
        }
        
        fetch(link, options)
        .then((response) => {
            if (!response.ok) {
                throw (response);
            }
            return response.json();
        })
        .then(
            (result) => {
                callback(result);
            })
        .catch((error) => {
            if (error.statusText) {
                this.setState({error: error})
            }
            callback(error);
        })
    }
    ```

    Now, refresh your application and make sure in the React Developer Tools, the `chores` state in the `Chores` component is populated with 7 chores. If you have any problems getting this to work, ask a TA for help.

## Populating the table

5. Add the following code after the `</thead>` tag (in your `render()` function)
    ```
    <tbody>
        { this.showChores() }
    </tbody>
    ```

6. Define the function `showChores` which will ....
    ```
    showChores = () => {
        return this.state.chores.map((chore, index) => {
            return (
                <tr key={index} >
                    <td width="125" align="left">{chore.child_id}</td>
                    <td width="200" align="left">{chore.task_id}</td>
                    <td width="75" align="center">{chore.due_on}</td>
                    <td width="125" align="center">{chore.completed ? "True" : "False"}</td>
                    <td width="50">Check</td>
                    <td width="50">Delete</td>
                </tr>
                )
        })
    }
    ```

## Improving the Chore Table

7. We realise that instead of the id of the child and task, it would be better to show the name of the child and the task. First, add `tasks` array and `children` array into your `state`. Your `state` should now look something like this:

```
state = { 
    chores: [],
    tasks: [],
    children: [],
}
```

8. Create high level functions to populate your `children` and `tasks` state. Remember to also add these high level functions to `componentDidMount()`

    Check your React DevTools to make sure `tasks` and `children` are successfully populated.

    ![Imgur](https://i.imgur.com/8ZRsmIm.png)

9. Now that we have all the `children`, we can map the `child_id` to the name of the child.

    ```
    find_child_name = (chore) => {
        var desired_id = chore.child_id;
        const children = this.state.children
        for (var child = 0; child < children.length; child += 1){
            if (children[child]['id'] == desired_id){
                return children[child]['first_name'].concat(' ', children[child]['last_name']);
            }
        }
        return "No name"
    }
    ```

10. Update your `showChores` function so that you would show the name of the child instead of the id. Hint: In order to call a function defined in the class, you should use `this.<functionName>(<parameter>)`

11. Now, do the same for `task` such that users would be able to see the name of the task instead of the id.

12. Now your page should look like this.

    ![Imgur](https://i.imgur.com/finf3Ai.png)

# Part 3: Adding a New Chore #

1. Generate a `NewChoreForm` Component. Hint: how did we first generate the `Chore` Component at the start of the lab?

## Toggling the `NewChoreForm`

2. We want the `NewChoreForm` to appear only when we click on the `Add New Chore` Button. Go back to `Chore.js`. We can create a `modal_open` variable in our state and default it to false by adding the following line in the `state` of the `Chores` component
    ```
    modal_open: false
    ```

3. Add `onClick={this.switchModal}` in the opening `<button>` tag and define the function `switchModal`. Your code should now look like `<button onClick={this.switchModal}>`
    ```
    switchModal = () => {
        this.setState(prevState => ({
            modal_open: !prevState.modal_open
        }));
    }
    ```
    Try clicking on the button and seeing whether the `modal_open` state changes in the React Developer Tool.

4. Now, we will toggle the `NewChoreForm` when the button is clicked. Add the following function in `Chores.js`
    ```
    showChoreForm = () => {
        return (
            <div>
                <NewChoreForm 
                    children={this.state.children}
                    tasks={this.state.tasks}
                    run_ajax={this.run_ajax}
                    switchModal={this.switchModal}
                />
            </div>
            )
    }
    ```
    We will also add the following line below the `<button>` tag which will call `showChoreForm` when `modal_open` is `true`.
    ```
    { this.state.modal_open ? this.showChoreForm() : null }
    ```

    Refresh the page and click on the `Add new chore` button. Did the application crash and give you the error `Uncaught ReferenceError: NewChoreForm is not defined`? This is because we need to import our `NewChoreForm` component to the start of our `Chores` component!

    Now, when you click on the `Add new chore` button, you would be able to toggle the `NewChoreForm` on the React DevTool.
    
    ```
    import NewChoreForm from './NewChoreForm';
    ```

## Creating the New Chore Form
5. Let's switch to `NewChoreForm.js` and create a skeleton `render` function with a `child` dropdown. 

    ```
    render() {
        return (
            <div>
                <form>
                    <label>
                      Child:
                      <select onChange={this.handleChildChange}>
                        { this.childrenOptions() }
                      </select>
                    </label>
                    <br />

                    <input type="submit" value="Submit" />
                 </form>
          </div>
        )
      }
    ```

    Now, we would need to define `handleChildChange` and `childrenOptions`

6. Creating `childrenOptions` function
    ```
    childrenOptions = () => {
        return this.props.children.map((child, index) => {
            return (
                <option value={index}> {child.first_name} </option>
            )
        })
      }
    ```

7. Knowing which `child` is selected by keeping track of it in `state`
    ```
    state = {
      child: this.props.children ? this.props.children[0] : null
    }
    ```

    ```
    handleChildChange = (event) => {
        this.setState({child: this.props.children[event.target.value]});
      }
    ```

8. Do the same for `task` and `due_on`.

    Hint: you would need to (1) (possibly) create options, (2) add form inputs (3) add variables to the state and (4) deal with the change of form inputs. 

    Hint: to create a datepicker, you can use `	<input type="date">`

## Submitting the form
9. Add the trigger by modifying the opening `<form>` tag
    ```
    <form onSubmit={this.handleSubmit}>
    ```

10. Now, whenever we click on the `submit` button, the form will call the `handleSubmit` function. Define the function
    ```
    handleSubmit = (event) => {
        event.preventDefault();
        const new_chore = {
                        child_id: this.state.child.id,
                        task_id: this.state.task.id,
                        due_on: this.state.due_on,
                        completed: this.state.completed
                    }
        this.props.run_ajax('/chores.json', 'POST', {"chore": new_chore});
        this.props.switchModal()
    }
    ```

11. Try to submit your form on the web application! Does the console give you useful information about why it is failing? What about your terminal - what is the error message when the POST request is being made? 

    ```
    Started POST "/chores.json" for ::1 at 2019-12-04 23:44:10 -0500
    Processing by ChoresController#create as JSON
      Parameters: {"chore"=>{"child_id"=>1, "task_id"=>1, "due_on"=>"2019-12-17", "completed"=>false}}
    Can't verify CSRF token authenticity.
    Completed 500  in 2ms (ActiveRecord: 0.0ms)
    ```

    In order to solve this problem, head over to `application_controller.rb` and replace `protect_from_forgery with: :exception` with `protect_from_forgery with: :null_session`

12. Now, try submitting your new chore form again.

# Part 4: Completing and Deleting Chores #

## Toggling Completion of Chore
1. Modify the `showChores` function in `Chores.js` by adding `onClick={() => this.toggle_complete(chore)}` in the `<td>` opening tag. You should get the following line of code:

```
<td width="50" onClick={() => this.toggle_complete(chore)}>Check</td>
```

Do you know why we need to use an anonymous function for onClick? Try `onClick = this.toggle_complete(chore)` later and see whether anything changes. Hint: investigate the `completed` property of chores in the React Dev Tools.

2. Let's define the `toggle_complete` function
    ```
    toggle_complete = (chore) => {
        const updated_chore = {
            child_id: chore.child_id,
            task_id: chore.task_id,
            due_on: chore.due_on,
            completed: !chore.completed
        }
        this.run_ajax('/chores/'.concat(chore.id, '.json'), 'PATCH', {chore: updated_chore});
    }
    ```

3. Try this out and make sure it works before moving on!

## Deleting a Chore
4. Modify the `showChores` function by adding `onClick={() => this.remove_record(chore)}` in the `<td>` opening tag.

5. Define the `remove_record` function
    ```
    remove_record = (chore) => {
        this.run_ajax('/chores/'.concat(chore['id'], '.json'), 'DELETE', {chore: chore});
    }
    ```