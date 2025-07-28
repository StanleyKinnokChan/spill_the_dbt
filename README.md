# Spill the dbt :tea:

A series of practical data transformation challenges with dbt, designed to help you get comfortable with dbt and its functionality.

These challenges generally follow the content for the [dbt Analytics Engineer Certification](https://www.getdbt.com/certifications/analytics-engineer-certification-exam), providing hands-on experience with concepts covered in the certification.

## Getting Started

To work with these challenges, please follow the steps below:


**1. Set up dbt cloud**
#### dbt Cloud

If you are using dbt Cloud, you can skip the installation and setup steps for dbt Core and instead use the Cloud IDE provided by dbt.

##### Sign Up for dbt Cloud
Create an account at [dbt Cloud Sign Up](https://www.getdbt.com/signup).

##### Create a New Project
After signing up, create a new project in dbt Cloud.

> **Note:** The layout of the dbt Cloud interface may change over time.  
> ![dbt Cloud Layout](https://i.imgur.com/U1R34WX.png)

##### Set Up Your Snowflake Connection
Configure the connection to your Snowflake account:


> ![Snowflake Connection](https://i.imgur.com/4Y47WXB.png)

##### Configure Development Credentials
Update your development credentials:

- Change your **schema name** so your modeled data is written to your own schema during development.
- **Test** the connection.
- **Save** the credentials.

> ![Development Credentials](https://i.imgur.com/tPZfZgD.png)

##### Integrate with GitHub
Connect your dbt Cloud project to a GitHub repository:

- Log into your GitHub account.
- Create a new repository to be managed by dbt Cloud.

> ![GitHub Integration](https://i.imgur.com/wcUgMZG.png)


You’re now all set and ready to move on to the challenge! ✅

---

**2. Work Through the Challenge**

- Follow the step-by-step instructions provided in the challenge markdown file.
- Write your dbt models, tests, and code as instructed.

**3. Optional: Download the managed repository**
If you follow the setup above, you are using a managed repository. You can download the repository to your local machine. The managed repository can be found in account-settings -> project -> project name -> repository.
After downloading the repository, you can choose to push the project to GitHub. 
> ![Download Repository](https://i.imgur.com/n7vJbDC.png)

**4. Optional: Share Your Solutions**

If you'd like to share your solutions on social:
- Use the hashtag **#SpillTheDBT** 
- Add an image of your code with [carbon.now.sh/](https://carbon.now.sh/) 
- Write about your solution and the techniques used to complete the challenge

If you'd like to contribute back to the project, you can create a pull request for [spill_the_dbt](https://github.com/wjsutton/spill_the_dbt).


## Challenges

| Week | Challenge         | Estimated Time                                    | Skills Tested | Walkthrough                                             | Solutions                                                |
|----- |-----------------------|------------------------------------------------------|-------|---------------------------------------------------------|----------------------------------------------------------|
| 1. | [Introduction to dbt-core](https://github.com/StanleyKinnokChan/spill_the_dbt/blob/main/tasks_cloud/challenge_01.md) | 1/2 a day      | - Basic connection profiles<br>- Migrating SQL code to dbt<br>- Running and testing models<br>- Referencing model outputs<br>- Generating documentation | Coming soon | [Solution](https://github.com/StanleyKinnokChan/spill_the_dbt_cloud_solution) |
| 2. | [Testing models to find errors](https://github.com/StanleyKinnokChan/spill_the_dbt/blob/main/tasks_cloud/challenge_02.md) | 1/2 a day        | - Generic & relationship tests<br>- Custom & singular tests<br>- Tests from dbt packages | Coming soon| [Solution](https://github.com/StanleyKinnokChan/spill_the_dbt_cloud_solution)

*More challenges coming soon!*

## Contributing

Contributions are welcome! If you have ideas for new challenges, improvements to existing ones, or want to share your solutions, please feel free to:

- Open an Issue: Use the GitHub Issues tab to discuss your ideas or report problems.
- Create a Pull Request: Fork the repository, make your changes, and submit a pull request for review.

Please ensure your contributions align with the project's goals and that you follow the contribution guidelines.

**Contribution Guidelines**

- Be respectful and considerate in your interactions.
- Avoid offensive or inappropriate language and content.
- Provide constructive feedback and be open to feedback on your contributions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Special thanks to the dbt community for their support and resources.
These challenges are inspired by the content for the dbt Analytics Engineer Certification.
