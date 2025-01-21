# Prompt Crafting techniques for GitHub Copilot every developer should know

Slides: https://microsoft-my.sharepoint.com/:p:/p/buhollan/EadM4RNYrTNAt92bh1-Tp5wBNX3shhWedXBiKEWXUtympQ?e=EMVgRr

## Demo Setup

This file contains a dev container with all of the necessary dependencies, including a Postgres database. It is highly recommended that you use this dev container for the project.

## Prerequisites (Skip for Dev Container)

1. [VS Code - Insiders](https://code.visualstudio.com/insiders/)
2. [GitHub Copilot](https://copilot.github.com/)
3. [Regex Preview](https://marketplace.visualstudio.com/items?itemName=chrmarti.regex)
4. [Postgres](https://www.postgresql.org/download/)
5. [Postgres Chat Participant](https://marketplace.visualstudio.com/items?itemName=robconery.pg-chat)

Add the following settings to your User Settings (JSON) file...

```json
"github.copilot.advanced": {
    "debug.conversation": true,
    "conversationLoggingEnabled": true
},
```

### Dev Container

After the container builds, open a terminal and run the following commands:

```bash
./setup/setup.sh
```

This will...

1. Create a database called "demos" 
2. Create a table called "vehicles" 
3. Seed the table with some publicly available data on electric vehicles registered in the state of Washington
4. Create a .env file and add the connection string for the database

You're ready to go!

## Demo Script

> So let's imagine, for a moment, that we (you and I dear viewer) are working for an agency we've been tasked with creating a web dashboard for all electric vehicles registered in the state. We're going to use Express and TypeScript to do that and we'll explore our advanced prompting techniques along the way.

### Chat Sidebar

> Before we get started, we want to do a little brainstorming about how we're going to structure this project. The GitHub Copilot Chat sidebar is ideal for thinking and planning. Let's ask GitHub Copilot to suggest a good project structure for this application. To do that, we'll use something called a "Q&A" strategy.

Add the following prompt to the chat sidebar...

```text
i am building an application to display electric vehicle data. I want to use express and typescript. Give me some options for how to structure this app. Ask me clarifying questions that will help you suggest the right folder structure.
```

> A Q&A prompt is particulary useful because not only does it show how the model is thinking about this problem, it jogs our brain for things that maybe we had not thought of.

The model should ask you questions. You can answer them with simple "Yes" or "No" with additional information if required. Separate your answers with a comma

> It suggests this nice folder structure. This is a bit verbose. You'll find that Copilot does this a lot - it's sort of thinking out loud here, but it's often too much to read - a small documentation article. So we're going to use the magic prompt word, which you'll see me use a lot today, and that is, "simple". Including this word in your prompts helps keep Copilot from trying to do too much, and makes it easier to quickly understand the response.

In the Chat Sidebar type the word "simplify". The model should return a much shorter, more simple response.

> Let's take this suggestion and start building our dashboard. I'm going to start with an empty `app.ts` file and create the basic express server. For this, we're going to use a different type of GitHub Copilot interaction - "Inline Chat".

Create a new file in the root of the project called `app.ts`.

### Inline Chat

> Inline Chat is how you can talk to Copilot from within your file. You should use Inline Chat when you want Copilot to write code _for_ you as part of the response.

Press Cmd / Ctrl + I to open Inline Chat. Add the following prompt...

```text
simple express server using typescript
```

Do not accept the models response, but leave the suggestion up. You will be iterating on it.

The model may or may not return a response that includes types for `req` and `res`. If it does not, you'll need to factor that into the next part where you iterate on the response. 

```text
use types for req and res
```

#### Iteration with Inline Chat

> This response is mostly what I want. But I forgot to tell it that I want it to serve a static HTML file for the root route. I've prepared this HTML file just for this demo and I want to serve that. So let's tweak the prompt..

Remove all the text from the Inline Chat box and type...

```text
serve public/index.html from the root route
```

Accept the suggestion

> The suggestion is now updated with the static HTML file being served - which required the path module from Node and a configuration of a static directory. Iteration is key with Copilot. Copilot doesn't know exactly what you want, and there is a high likelihood that _you don't know that either_.

> For instance, I've just realized, in this demo, that serving up a static HTML file probably isn't the best example of an Express app in real life - usually Express apps have views and use a template laguage. This static HTML file feels like a bit of a cop-out. But I've already accepted the selection? Now what?

#### The Importance Of Selecting Text

> I can resume my iteration by selecting all of the text here and opening the Inline Chat again. This is a good habit to get into with GitHub Copilot - select the relevant text from the editor when you use either inline or sidebar chat. This selected text always gets sent with the prompt, so it's a good way to know that you are providing the right context.

Select all of the text in the file and open the Inline Chat with Ctrl/Cmd + I.

Enter "use the pug view engine" for the prompt.

Accept the suggestion from Inline Chat.

Update the `app.get` route to pass an empty vehicles array to the template

```typescript
app.get('/', (req, res) => {
    res.render('index', { vehicles: [] });
});
```

> OK! Now we've got Pug wired up as our view engine. But now my HTML file is useless since we're using Pug instead. 

Open the public/index.html file. Rename it to "views/index.pug". Select all of the text and trigger the inline chat with Ctrl + I and enter the following prompt...

```text
convert this to pug
```

> GitHub Copilot is really good at translating between different languages and formats. Here it converts the markup to Pug AND it updates the logic to reference a Pug variable called "vehicle". However, it doesn't delete the JavaScript at the bottom. Deleting code is a big deal. You want to be very careful about that with an AI Tool, so Copilot leaves that part in case we still want it. We don't, so we can delete it.

Delete all of the JavaScript from the first script tag until the end of the file, including the Vue include.

> Ok! We've done a lot of work. Well, Copilot has done a lot of work. Good job, pair programmer! Let's make sure what we've got so far is working.

Open the terminal in VS Code.

> We'll initialize a new TypeScript configuration here so that we can compile our TypeScript files and run this.

```bash
tsc --init
```

> Before we compile this, though. I want to check and see if the NODE_ENV variable is set in this environment. The same inline chat that you use in the editor is also available in the terminal. 

```text
print out all env vars
```

> It looks like that variable is NOT set. I can never remember how to set it, so let's ask for that. Notice that when we do, we get an answer that we can update with the value we want for the var. The terminal inline chat knows about my terminal - and suggests the right PowerShell Commands for me.

> As a side note, the terminal inline chat is one of my favorite features of Copilot because now I can do anything. For instance, I can ask how many folders are in the node_modules folder. Just in case you're curious how many dependencies it takes to run an Express app.

```text
count the number of folders in node_modules
```

> OK, let's compile and run.

```bash
tsc
node app.js
```

This should start the app and you can navigate to `http://localhost:3000` in your browser to see the app.

### Ghost Text

> Now, so far GitHub Copilot has written a lot of code. Strike that, it's written _all_ the code. And this is because this is a demo and these examples are simple. In the real world, this won't be the case. The code you'll be working with is too complex for GitHub Copilot to just write all of it. In the real-world, the iteraction that you'll likely use the most often with GitHub Copilot is "Ghost Text".

Create a file called "data/db.ts".

Add the following import...

```typescript
import pg from 'pg'
```

> Ghost Text are the completions that you'll get in your editor. And they are _powerful_. They are powerful because the prompt is your code. It is also any other tabs that you might have open. This is the context that GitHub Copilot uses to provide completions.

> Another way to get a completion is to use a comment. We might call this "comment driven development".

Add the following comment

```typescript
// create a new connection pool
```

> Note that I have to know at this point that I need a connection pool. Copilot could have told us this, but we already know, so we do it. But Copilot helps with completions as we're typing.

Start typing the following code and let completions help you out...

```typescript
const pool = new pg.Pool({
```

The final code should look like this...

```typescript
const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
});
```

> I want to expose a function that will allow me to query the database. And once again, completions help me out here.

Start typing the following code and let completions help you out...

```typescript
export async function query(
```

The final code should look like this...

```typescript
function query(text: string, params: any[]) {
  return pool.query(text, params);
}
```

> Finally, we want to export something here. I'm assuming that Copilot will anticipate this and give me a completion for it without having to type anything at all. 

Press "Enter" after the `query` function and Copilot should generate the following completion...

```typescript
export default {
  query,
};
```

> One thing you may have noticed is that Copilot uses the process.env, but we likely have that connection info in a file. We need to read that file in. We can use the dotenv package to do that.

Put your cursor at the end of the "pg" import and press "Enter". Copilot should generate the following completion...

```typescript
import dotenv from 'dotenv';
```

> Copilot is now anticipating what I need and I don't need to ask for anything. This is when Copilot is truly magical. I just need to know that I need it, I don't actually have to even ask for it.

Press "Enter" again after the `dotenv` import and Copilot should autmoatically add the following completion...

```typescript
dotenv.config();
```

> Again - I have to know that I need this. I can't stress this enough - the more that you know what you are doing, the better results you will get from Copilot. There is no substitute for experience, y'all. Copilot can increase your productivity, but that is directly proportional to your ability and knowledge of the code you are working with.

> OK, we have a database connection, let's create a service to retrieve all the vehicle data. For the sake of speed, I have a snippet for that. And then finally we need a route file too - so again - pretend we wrote all of this beautiful code.

Add a file called "services/vehicleService.ts" and add the following code...

```typescript
import { Request, Response } from 'express';
import db from '../data/db'; // Ensure this path is correct for your project structure

const vehicleService = {
    async getAllVehicles() {
        try {
            const result = await db.query('SELECT * FROM vehicles LIMIT 100', []);
            return result.rows;
        } catch (err) {
            console.error(err);
            return [];
        }

    }
}

export default vehicleService;
```

> And let's use this service on the root route to return data to our view.

Modify the root route in `app.ts` to be the following...

```typescript
app.get('/', async (req: Request, res: Response) => {
    const vehicles = await vehicleService.getAllVehicles();
    res.render('index', { title: 'Vehicles', vehicles: vehicles });
});
```

> OK - let's run and see if we a vehicle dashboard. We do not! We have an error. 

> Copilot does a lot behind the scenes to compose prompts for you - we've seen that. A lot of it is done for you. As we've seen selecting text is always a good option when asking a question. Having the relevant code open is also always a good idea since Copilot always passes whatever is in the visible editor space. 

> There are some prompts that get written so often that they are actually baked into Copilot. We call these "Slash Commands".

### Slash Commands

> Slash commands are pre-packaged and optimized prompts for common tasks. For instance, a common need is to document a function. Copilot has a slash command for that. 

Open the vehicleService file and make sure it is visible in the editor.

Select the `getAllVehicles` function. Press Cmd/Ctrl + I to open Inline Chat and add the following prompt:

```text
/doc
```

Copilot should generate a JSDoc comment for the function.

> Perhaps the most important pre-packged prompt in all of Copilot, is /fix. If we examine the error in our terminal, we can see we have a syntax error at or near 100. That's odd. This is a pretty simple query. Let's see if Copilot can help us out with the /fix command. I'm going to select the query and run the /fix command.

Select the query (line 6) in the `vehicleController` and press Cmd/Ctrl + I to open Inline Chat. Add the following prompt:

```text
/fix
```

Copilot will make some suggestion that is wrong.

> OK, so we're getting a suggestion here, but I can look at this right away and know this is wrong. It's important to note that the more experience you have and the more you know a framework or language, the more help copilot is going to be for you. This is because it _does_ give wrong answers. And if you can spot those immediately, you can save yourself a lot of time. It's a tricky situation to be in with Copilot when you have no clue what you are doing and you have no idea if it's giving a correct answer, or just something that looks correct, but is going to waste the next 30 minutes of your time because it's ultimately wrong.

> In this case - I know this suggestion is wrong. My guess is that Copilot needs more context here. So I have a few options - I could select all of the text in the editor and run the /fix command again. But what I really need here is for Copilot to understand everything about my project. We've talked about how it doesn't know about every file. But there is a way to give it that context.

### Participants

> Participants are experts within Copilot on specific topics. They are "trained" (in a manner of speaking) on specific content. For instance, there is a @vscode participant. This participant is an expert in all things VS Code. We might ask this participant how to hide the JavaScript files in this project.

Add the following prompt to the Chat Sidebar:

```text
@vscode how do I hide the JavaScript files in this project?
```

You should get back a completion that tells you how to hide the JavaScript files in the editor. Add that to a `.vscode/settings.json` file.

> There is also a @workspace participant. It knows about your project. If the project is a public GitHub repo, then the participant uses the GitHub index. If it's not, the index is created locally for you on your machine. The participant then queries this index when you use it to ask a question. It will be able to know things like your project structure, the files in your project, what languages are being used, packages, et. 

Add the following prompt to the sidebar...

```text
@workspace what kind of project is this and what is it doing
```

> You can see that the chat now knows a LOT about my project. It knows that it's TypeScript, it knows that it's Express. It knows that it uses Postgres. It knows that we're working with vehicle data. It even knows about our String class! Nice!

> So let's try this fix again and involve our local workspace expert. I'm going to highlight the line again and run the /fix command. But this time, I'm going to involve the @workspace participant.

Make sure the query line is selected and add the following prompt to the Chat Sidebar:

```text
@workspace /fix
```

> This time, Copilot catches the error. The "TOP" keyword is not valid for Postgres. I didn't know that - I'm used to SQL Server. Apparently we're supposed to use LIMIT instead. Let's make that change. 

Stop the running app in the node terminal window and then start again with: 

```bash
node app.js
```

Navigate to `http://localhost:3000/api/vehicles` in your browser. You should see a list of vehicles.

> This is a great example of how Copilot can catch "silent errors". These are errors that aren't caught by the compiler or linter. Those are easier to resolve. The hard ones are the ones that fail only when the app runs. Copilot is _really_ good at fixing these errors and catching your silly mistakes. When asking for a /fix, I always like to involve the @workspace participant.

> There is one more important concept to understsand when prompting Copilot - the idea of "variables".

### Variables

> Variables are a way to pass certain specific pieces of context to GitHub Copilot. For instance, we've talked about how important it is to always select the most relevant code to your prompt. But sometimes you need to reference an entire file. You can do this with a variable.

> For instance, right now we are returning JSON data from our service, but we're not using a model. Ideally we would return an array of vehicle model objects. For that, we need a model. I happen to have some of the vehicle data from the database in a CSV file here. What we can do is to ask Copilot to generate a model for us. But we need to give it the context of the file.

> Let's start a new chat in the chat sidebar. It's important to clear out old context since Copilot is using the history of this chat to inform it's answers. You can always roll back to a previous chat with the history button here.

Clear the sidebar chat with the + button at the top.

Enter the following prompt:

```text
create a typescript model that matches the shape of #file:vehicles.csv
```

You'll get a pop-up when you use the #file variable that you can use to select the file. Select the `vehicles.csv` file.

Copilot should generate a model file for you. You can iterate on its result if it's not exactly what you want. If you get a verbose result, you can ask for a "simple" version.

> Very handy. There are other variables that you can explore. You can see some experimental ones in here, because this is Insiders - like #web, that does a web search in the background to accompany your prompt. Or #terminalLastCommand which looks at the last command that was run in the terminal and the output. This can be great for debugging errors that you get in the terminal.

> But this - what I just did - this is a bit of a contrived example. In the real world, you don't have a CSV file that matches your database just sitting around conveniently. No. You have a database. If only GitHub Copilot could know about _your_ database...

> As you may know, quite possibly the best thing about VS Code isn't really VS Code at all. It's the extensions that are available. These are the things that make VS Code so powerful. If you're a VS Code user, you know exactly what I'm talking about and you likely have your own favorite extensions.

> And now, extension authors can tie directly into GitHub Copilot to build their own participants, variables and slash commands. 

> For instance, I have an extension installed called "PG Chat Participant". This extension adds a Postgres participant is an expert on my database. My actual database. I have already given it the connection info. So I can ask it questions about the database - like what tables are there. 

In the chat sidebar, ask the Postgres participant for the tables in the database:

```text
@pg /show
```

> It can write also write SQL queries for me. 

Add the following prompt to the Chat Sidebar:

```text
@pg select all the cars from the vehicles table that are a TESLA
```

It should return a query you can run directly in the editor.

> Notice that I never mentioned the column name here. Copilot does this on its own - it's doing the thinking for me. And it can handle a lot of complexity. We've worked with it a lot and it can handle pretty nasty joins and things like common table expressions as well. You just tell it what you want and because it knows the schema of the database, it can write the query for you.

> And yes - it can generate that TypeScript model file directly from my database. BTW - this table has over 140K rows in it - not something that would be feasible to put in a CSV file! But it's no problem for the @pg participant.

Add the following prompt to the Chat Sidebar:

```text
@pg generate a typescript model for the vehicles table
```

> And there we go - a model file that matches the shape of the vehicles table in my database.

Go back to slides for Conclusions & Wrap Up.

## Bonus Content

You can add in some of these additional exercises / demos to fill out any remaining time.

### Testing

> Testing is a great use case for GitHub Copilot. This is because tests are mostly boilerplate. They are reptitive and are often derrived from your implementation, unless you're doing something like TDD.

> Let's start by creating a test file for our `vehicleController`. The problem is, I don't know much about testing. So I'm not sure how to even set tests up here. Based on what we've learned so far, what is the best way for us to interact with GitHub Copilot in this scenario?

Pause and let people suggest. The answer is something like "Chat Sidebar" or "Brainstorm". We're looking for an answer that shows that people understand that Ghost Text or Inline Chat is probably not the best way to go here.

> Exactly. We need to do a little Q&A with Copilot. Let's start a new chat in the Chat Sidebar.


