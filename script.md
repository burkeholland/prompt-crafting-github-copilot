# Crafting Good Prompts with GitHub Copilot

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

> But there are times when you need to do a lot more. You need to have an actual conversation with Copilot. This happens a lot when you are brainstorming certain ideas 





