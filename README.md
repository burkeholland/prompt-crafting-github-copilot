# Crafting Good Prompts with GitHub Copilot'

## Prerequisites

1. [VS Code - Insiders](https://code.visualstudio.com/insiders/)
2. [GitHub Copilot](https://copilot.github.com/)
3. [Regex Preview](https://marketplace.visualstudio.com/items?itemName=chrmarti.regex)
4. [Postgres](https://www.postgresql.org/download/)
5. [Postgres Chat Participant](https://marketplace.visualstudio.com/items?itemName=robconery.pg-chat)

## Setup

Add the following settings to your User Settings (JSON) file...

```json
"github.copilot.advanced": {
    "debug.conversation": true,
    "conversationLoggingEnabled": true
},
```

Rename the RENAME_ME.env to .env and add your Postgres connection string.

> Crafting good prompts with GitHub Copilot depends a lot on how and where you are using GitHub Copilot. How you use Copilot is almost more important than the the prompt itself. There are essentially 3 interaction models that you'll use in VS Code when working with Copilot - Ghost Text, Inline Chat and Chat Sidebar / Quick Chat.

> Knowing how and when to use these different interaction models is key to getting the most out of your prompt with Copilot. Let's take a look at each one in more detail.

## Ghost Text

1. Open the app.ts file

> Ghost Text" is the term we use to describe the inline completions that GitHub Copilot provides in the editor. 

1. Start by typing out a function to reverse a string. GitHub Copilot should complete this for you.

```typescript
function reverse
```

2. You should see a completion that looks like this. You may or may not get the type for string. If you do, call it out.

```typescript
function reverse(str: string): string {
  return str.split('').reverse().join('')
}
```

> In this example, we use GitHub Copilot to write a function that reverses a string. This is a simple example, so we don't need to provide a lot of context. And in this case, you can see that GitHub Copilot uses the context that it has - the fact that we're in a TypeScript file - to provide a completion that includes the type for the string parameter.

> This is an important concept with GitHub Copilot - Simple. The more simple the solution, the more accurate GitHub Copilot will be. We generally talk about this as the 3S's - Simple, Specific and Short. When working with Ghost Text - try and keep your prompts simple, be specific in what you ask for and keep it short - move in steps and let GitHub Copilot build on what you have.

> The other way that you can "prompt" Ghost Text, is with a comment. So we could ask for a function that removes all HTML tags from a string.

Underneath the function that you just wrote, add a comment that says:

```typescript
// A function that removes all HTML tags from a string
```

This should generate a completion that looks like this. 

```typescript
function removeHtmlTags(str: string): string {
  return str.replace(/<[^>]*>/g, '')
}
```

> Copilot gives us a regular express here. Because regex is hard for us as humans, but Copilot likes it and is really good at it. BUT, you never want to just assume that the regex is correct. Use your editor tools to check the regex. In this case, we'll use the Regex Preview extension to check the regex. "Trust, but verify" is a good rule of thumb when working with Copilot.

> So a "prompt" when using Ghost Text is the code that is already in the editor and any comments that you've provided. You don't have much control over the prompt here - GitHub Copilot is doing that for you in the background. The best you can do is understand what Ghost Text knows about and is likely sending as part of the prompt.

> One trick you can use with Ghost Text to get more control over the prompt is to use a comment at the top of a file.

Delete everything in the `app.ts` file.

Add a comment at the top of the file that says:

```typescript
// This file extends the string prototype with some useful functions...
// 1. reverse - reverses a string
// 2. removeHtmlTags - removes all HTML tags from a string
// 3. capitalizeFirstLetter - capitalizes the first letter of a string 
```

Press enter after the comment and GitHub Copilot should start generating the correct code for you to do exactly what the prompt says in the comment.

```typescript
interface String {
    reverse(): string;
    removeHtmlTags(): string;
    capitalizeFirstLetter(): string;
}

String.prototype.reverse = function (): string {
    return this.split('').reverse().join('');
};

String.prototype.removeHtmlTags = function (): string {
    return this.replace(/<[^>]*>/g, '');
};

String.prototype.capitalizeFirstLetter = function (): string {
    return this.charAt(0).toUpperCase() + this.slice(1);
};
```

> In this case, we asked more of GitHub Copilot with the prompt, but we also gave it a lot more context. This strategy of using bullets when talking with GitHub Copilot is a great way to give it more context. The more context you give it, the more accurate it will be. Notice that even though this file is doing quite a bit, it's still simple, specific and short.

> Let's say we want to add one more function here. Let's add one that removes a specific character from a string. 

Add a comment to the top of the file that says:

```typescript
// removes a specific character from a string
```

Copilot generates the following completion:

```typescript
String.prototype.removeCharacter = function (char: string): string {
    return this.replace(new RegExp(char, 'g'), '');
};
```

> Notice that at this point, we don't have to tell it we want to extend the string prototype. We know that GitHub Copilot already knows about the rest of the code in this file, so we don't need to make that part of the prompt - it's already there.

> Now we have an error because we're trying to add a function that we haven't defined in the interface. And guess what - GitHub Copilot already knows that as well. If we just put our cursor in the interface and add a new line, GitHub Copilot will add the correct function signature. In this case, we don't need a prompt AT ALL. You'll likely find that this is the most powerful and magical use case for AI - when it can anticipate what you need before you even ask for it. Because the best prompt is the one that you don't have to write.

> Let's move our string functions to a different file. We'll use VS Code's built-in refactoring to do this.

Highlight all of the text in the file and press Cmd/Ctrl + . to bring up the quick fix menu. Select "Move to a new file" and name the file. VS Code will move all of this to a file called `String.ts`.

Open the sidebar and note that the `String.ts` file has been created, but **do not open it**.

> We'll import the new `String.ts` file into our `app.ts` file and start using the functions that we created.

Add the following import statement to the top of the `app.ts` file:

```typescript
import './String'

const message = 'Hello, <strong>world</strong>!'
```

> Now we ask GitHub Copilot to reverse the message

Start typing the following code...

```typescript
const reversedMessage 
```

GitHub Copilot should complete this for you.

```typescript
const reversedMessage = message.reverse()
```

> Awesome! Now let's remove those pesky HTML tags. 

Write a comment that says:

```typescript
// strip out all HTML tags
```

Copilot should get this wrong. It will likely generate a completion that looks like this:

```typescript
const strippedMessage = message.stripTags();
```

Note - If GitHub Copilot gets this right, make sure that `String.ts` **is not open** in the editor. Remove the line and restart the editor. Try the prompt again.

> Whoa. What happened here? That's not the function we wanted. And if we look at the string object, we can see our function is clearly there. 

Delete the bad function and press the `.` key after the `message` to see the intellisense. Look for the `removeHtmlTags` function. 

> VS Code knows about the correct function. It's right there. Why is GitHub Copilot getting this wrong?

> It's because GitHub Copilot doesn't know about this function at all - despite the fact that it **just wrote it**. Why? Because it's in a different file. GitHub Copilot doesn't know about the functions in the `String.ts` file because it's not open in the editor. This is important to understand. GitHub Copilot is not like you - it does not have an infinite memory. It only knows about what's in the editor at the time, as well as some of the code that's in other open tabs. In this case, if we want Copilot to know about the functions in the `String.ts` file, we need to open that file as a tab in the editor.

Open the `String.ts` file and try the prompt again:

```typescript
// strip out all HTML tags
```

This time, GitHub Copilot should generate the correct completion:

```typescript
const strippedMessage = message.removeHtmlTags()
```

> So with Ghost Text, remember these things - Keep your prompts simple, specific and short. Keep related files open in tabs so that GitHub Copilot can see the code that you're working with. And remember to give Copilot a chance to anticpate your next move - it's really good at that. 

> Now, Ghost Text is powerful, but there are limitations. First off, prompting copilot with a bunch of comments is going to leave a bunch of comments weird comments strewn throughout your code. I mean you _should_ comment your code, but not like this. These comments are only for Copilot, not for you or anyone else that might read your code. There is also the issue of interation. There isn't really a good way to have an interaction here with GitHub Copilot. To correct it's answer, change the subject, add more context - etc. 

> So let's look at the next interaction model - Inline Chat.

## Inline Chat

Setup by deleting everything in the `app.ts` file.

> Inline chat is exactly what it sounds like - a chat that you have with GitHub Copilot right in the editor. For example, lets start here in this empty file by asking for something a bit more complex. But we're still going to keep it as simple as possible. Let's build a web server using Express.

Press Cmd/Ctrl + I to open the Inline Chat interface and add the following prompt:

```text
a simple express server
```

Copilot should generate the following completion. Do not accept it:

```typescript
import express from 'express';

const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello, world!');
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
```

> This is kind of what we want, but not really. For instance, we're missing types for req and res, and maybe we want to return a static HTML file instead of just a string. We could have put that in the intial prompt. But we didn't. And this is the tricky part about prompt engineering - it's mostly trial and error. We didn't know that Copilot wasn't going to give us the types and maybe we just forgot about the static HTML file. Prompts should be iterative - you should be able to build/change them on the fly. And you can do exactly that with Inline Chat.

> So let's correct a few of these things. First, let's ask for types.

With the inline suggestion still open, remove the text in the inline chat box and add the following prompt:

```text
add types to req and res
```

Copilot should iterate on it's previous response to add the types. Do not accept it:

> Now let's ask for a static HTML file to be returned on that root route.

With the inline suggestion still open, remove the text in the inline chat box and add the following prompt:

```text
return a static HTML file on the root route
```

Copilot should iterate on it's previous response to add the static HTML file. Accept the final completion.

> OK! Much better. We iterated on our prompt and got exactly what we wanted. But we still kept it pretty simple so that Copilot could do it's thing. But let's say that we've now dismissed the inline chat and we want to use chak to display a nice message that lets the user go directly to the site from the terminal. But we closed the chat. How do we iterate on that prompt now?

> All we need to do is select the code we want to deal with and bring Inline Chat back. 

Select just the code that starts the server and press Cmd/Ctrl + I to open the Inline Chat interface. Add the following prompt:

```text
use chalk to display the app url
```

Copilot should not only add the chalk code to the highlighted method, but it should add the import at the top of the file as well.

> Notice what happened here - Copilot had to update our file in 2 places: the code that uses chalk AND the import. This is a good example of how Inline Chat is parsing the prompt in the background to try and help you out. It's not enough to update the code we've selected - we also need to update a part of the file that wasn't even included in the prompt. Or was it? Let's look at the prompt!

Open the Bottom Panel in VS Code and select the "Output" tab. Select "GitHub Copilot Chat" from the drop down. Scroll up until you see "SYSTEM". Below this you will see the system prompt.

> Here we have the SYSTEM prompt. This is what Copilot is sending for you as part of the prompt that you don't have to write. For instance, it is using a "Role" strategy here - assigning Copilot a role as an AI programming assistant. Part of that role is being an "expert" in TypeScript. Then it tells the AI that it will be sending all of the code, and just the code that the user has selected. If we scroll down a bit, we'll see "USER". That's your prompt. Well, kind of. The first part is a USER prompt that Copilot assembled for you. It's a summary of the context - the entire code in the viewable editor space, as well as the code that is selected. The second user prompt is the one that you actually wrote. But again we see another line we did not write - "the modified code...". Behind the scenes GitHub Copilot is engineering a pretty impressive prompt for you. You are part of that engineering. When you select code, you're helping. When you are simple, specific and short - you are helping!

> Now, Inline Chat can be found in the editor, but it can also be found in the terminal.

Open the terminal in VS Code and press Ctrl/Cmd + I to open the inline chat.

> Your terminal is a different environment than your code. Maybe it's bash, or zsh - or in my example, PowerShell. That means that Copilot in your terminal needs to know about your terminal when you ask a question. So let's ask a question that is specific to PowerShell.

In the terminal, add the following prompt:

```text
get the total number of folders in node_modules
```

You should get back a command that will run in the terminal.

> Notice that we get back a specific command that we can run with Cmd/Ctrl + Enter. We don't get back any explanatory text. This is because we asked a very specific thing. Remember - simple, specific and short.

> Let's ask Copilot how we can compile the TypeScript in this project.

Add the following prompt to the Inline Chat in the terminal:

```text
compile app.ts
```

You should get back a command that will run in the terminal.

> Great! Now let's run this with Node - and there we go - up an running.

> But there are times when you need to do a lot more. You need to have an actual conversation with Copilot. This happens a lot when you are brainstorming certain ideas, you need to examine more complex code, etc. This is where the Chat Sidebar comes in.

## Chat Sidebar

> The Chat Sidebar is a more "traditional" chat interface. It's one that a lot of people are used to because of things like ChatGPT. And while you will spend a lot of time interacting with Copilot in the editor, the Chat Sidebar is where you can have a more in-depth conversation.

> Let's start by opening the Chat Sidebar. Press Cmd/Ctrl + B to open the sidebar and you'll see the chat icon. Click on that to open the Chat Sidebar.

Open the Chat Sidebar.

> Now let's do some more complex brainstorming here. What I want to do is build an application to display electric vehicle data that I have in a postgres database. We already have the simple Express server, but I would like some help with how I should structure the application. 

Add the following prompt to the Chat Sidebar:

```text
I am building an express web application that displays electric vehicle data from a database. Ask me 5 questions about my project that will help you suggest a good file and folder structure.
```

It's hard to know exactly what you'll get back here, but it's likely that it's a list of 5(ish) questions. You can answer them yes/no, or with more context...

```text
1. postgres
2. No
3. No
4. Yes - use Jest
5. No
```

Press "Enter" again and GitHub Copilot will return a folder structure along with some explanation of what it all does.

> Here we used a strategy of having Copilot ask us questions. You can do this - you don't have to be the one asking all the questions. This is a great way to get Copilot to jog your brain for things you haven't thought of yet. Another strategy that you can use here is to ask for variations along with the trade-offs of each approach.

Add the following prompt to the Chat Sidebar:

```text
i want to create a db access file for postgres that uses one connection per session. give me some options for how to do this - include tradeoffs
```

You should get back a few different options along with some trade-offs.

> Let's use Option 1 here and ask for a few alterations to the code copilot suggested.

Add the following prompt to the Chat Sidebar:

```text
Use option 1. Use .env file for settings.
```

You should get back a completion that uses the .env file for settings. Click the ellipsis on the code block and select "Insert into New File". Name the file `db.ts`.

> Now let's take some of the earlier folder structure suggestions - specifically having a "controllers" folder. I like this pattern. For the sake of time I'll add the vehicle controllers code and the vehicle router code to this project. 

Add a file to the project called `controllers/vehicleController.ts` and add the following code:

```typescript
import { Request, Response } from 'express';
import { query } from '../data/db';

export const getAllVehicles = async (req: Request, res: Response) => {
    try {
        const result = await query('SELECT TOP 100 * FROM vehicles', []);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'An error occurred while fetching vehicles' });
    }
};
```

Add a file to the project called `routes/vehicleRouter.ts` and add the following code:

```typescript
import express from 'express';
import { getAllVehicles } from '../controllers/vehicleController';

const vehicleRouter = express.Router();

vehicleRouter.get('/', getAllVehicles);

export default vehicleRouter;
```

Leave both of these tabs up and return the `app.ts` file. 

> Now let's import the `vehicleController`. We have it open as a tab so we can be relatively sure the Copilot knows about it. And when we ask for the import, we'll get the correct completion. Even better, remember that Ghost Text can anticipate, so if we move down to use the router and press enter, Copilot will likely use the router for us. Then we can tweak the URL just slightly.

> Let's compile again - this time we'll add a watch flag so that we can see the changes in real time. And we'll run the server. If we head over to /api/vehicles, we should see the data.

In the terminal, stop the node server and run the following command:

```bash
tsc -w
```

Open a new terminal tab and run the following command:

```bash
node app.js
```

Navigate to `http://localhost:3000/api/vehicles` in your browser. You should see "server error".

> OK - we have an error here. Let's go back to the `vehicleController` and see what's going on.

> Copilot does a lot behind the scenes to compose prompts for you - we've seen that. A lot of it is done for you. As we've seen selecting text is always a good option when asking a question. Having the relevant code open is also always a good idea since Copilot always passes whatever is in the visible editor space. 

> There are some prompts that get written so often that they are actually baked into Copilot. We call these "Slash Commands".

## Slash Commands

> Slash commands are pre-packaged and optimized prompts for common tasks. For instance, a common need is to document a function. Copilot has a slash command for that. 

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

## Participants

> Participants are experts within Copilot on specific topics. They are "trained" (in a manner of speaking) on specific content. For instance, there is a @vscode participant. This participant is an expert in all things VS Code. We might ask this participant how to hide the JavaScript files in this project.

Add the following prompt to the Chat Sidebar:

```text
@vscode how do I hide the JavaScript files in this project?
```

You should get back a completion that tells you how to hide the JavaScript files in the editor. Add that to a `.vscode/settings.json` file.

> There is also a @workspace participant. It knows about your project. If the project is a public GitHub repo, then the participant uses the GitHub index. If it's not, the index is created locally for you on your machine. The participant then queries this index when you use it to ask a question. It will be able to know things like your project structure, the files in your project, what languages are being used, packages, et. 

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

## Variables

> Variables are a way to pass certain specific pieces of context to GitHub Copilot. For instance, we've talked about how important it is to always select the most relevant code to your prompt. But sometimes you need to reference an entire file. You can do this with a variable.

> For instance, right now we are returning JSON data from our controller, but we're not using a model. We're using an object and putting the directly in the response. Ideally we would tell the JSON what to convert to here. For that, we need a model. I happen to have some of the vehicle data from the database in a CSV file here. What we can do is to ask Copilot to generate a model for us. But we need to give it the context of the file.

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

> For instance, I have an extension installed called "PG Chat Participant". This extension adds a Postgres participant is an expert on my database. My actual database. I have already given it the connection info. So I can ask it questions about the database - like what tables are there. It can write SQL for me. And yes - it can generate that TypeScript model file directly from my database. BTW - this table has over 140K rows in it - not something that would be feasible to put in a CSV file! But it's no problem for the @pg participant.

### Bonus Content

You can add in some of these additional exercises / demos to fill out the remaining time.



